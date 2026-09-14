package com.avernet.signal.news;

import com.avernet.signal.exception.NewsNotFoundException;
import com.avernet.signal.news.news_categories.NewsCategoriesEntity;
import com.avernet.signal.news.news_categories.NewsCategoriesRepository;
import com.avernet.signal.news.news_countries.NewsCountriesEntity;
import com.avernet.signal.news.news_keywords.NewsKeywordsEntity;
import com.avernet.signal.user.UserEntity;
import com.avernet.signal.user.UserMapper;
import com.avernet.signal.user.UserRepository;
import com.avernet.signal.user.UserService;
import com.avernet.signal.user_news.UserNews;
import com.avernet.signal.user_news.UserNewsEntity;
import com.avernet.signal.user_news.UserNewsRepository;
import com.avernet.signal.user_news.UserNewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NewsService {

    private final RestClient restClient;

    private final NewsMapper newsMapper;

    @Value("${newsdata-api-key}")
    private String apiKey;

    private final UserService userService;
    private final UserNewsService userNewsService;

    private final NewsRepository newsRepository;
    private final NewsCategoriesRepository newsCategoriesRepository;
    private final UserRepository userRepository;
    private final UserNewsRepository userNewsRepository;

    private final UserMapper userMapper;

    @Transactional
    public List<News> findAllNews(String uuid) {
        List<NewsEntity> newsEntityList = newsRepository.findAll().stream()
                .sorted(Comparator.comparing(NewsEntity::getPublicationDate).reversed())
                .toList();

        Optional<UserEntity> userEntity = userRepository.findByUuid(uuid);

        return newsEntityList.stream()
                .map(newsEntity -> {
                    News news = newsMapper.toDto(newsEntity);

                    userEntity.flatMap(entity -> entity.getUserNews().stream()
                            .filter(un -> un.getNews().getId().equals(news.getId()))
                            .findFirst()).ifPresent(un -> {
                        news.setReadAt(un.getReadAt());
                        news.setBookmarked(un.isBookmarked());
                    });
                    return news;
                })
                .toList();
    }

    @Transactional(readOnly = true)
    public News getNews(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow((NewsNotFoundException::new));

        return newsMapper.toDto(newsEntity);
    }

    @Transactional(readOnly = true)
    public ResponseEntity<byte[]> getPublicationImage(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow(NewsNotFoundException::new);
        RestClient restClient = RestClient.create();

        ResponseEntity<byte[]> response = restClient.get()
                .uri(newsEntity.getImageUrl())
                .retrieve()
                .toEntity(byte[].class);

        return ResponseEntity.ok()
                .contentType(Objects.requireNonNull(response.getHeaders().getContentType()))
                .body(response.getBody());
    }

    @Transactional(readOnly = true)
    public ResponseEntity<byte[]> getSourceIcon(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow(NewsNotFoundException::new);
        RestClient restClient = RestClient.create();

        ResponseEntity<byte[]> response = restClient.get()
                .uri(newsEntity.getSourceIcon())
                .retrieve()
                .toEntity(byte[].class);

        return ResponseEntity.ok()
                .contentType(Objects.requireNonNull(response.getHeaders().getContentType()))
                .body(response.getBody());
    }

    @Transactional(readOnly = true)
    public List<String> getCategories() {
        return newsCategoriesRepository.findCategories();
    }

    @Transactional(readOnly = true)
    public List<News> findByCategory(List<String> category) {
        List<NewsEntity> newsEntityList = newsRepository.findDistinctByCategories_CategoryInOrderByPublicationDateDesc(category);
        return newsMapper.toDtoList(newsEntityList);
    }

    @Transactional
    public News markNewsAsRead(Long newsId, String uuid) {
        UserNewsEntity userNewsEntity = createOrUpdateUserNews(newsId, uuid);
        userNewsEntity.setReadAt(LocalDateTime.now());

        return newsMapper.toDto(userNewsEntity);
    }

    @Transactional
    public News toggleBookmark(Long newsId, String uuid) {
        UserNewsEntity userNewsEntity = createOrUpdateUserNews(newsId, uuid);
        userNewsEntity.setBookmarked(!userNewsEntity.isBookmarked());

        return newsMapper.toDto(userNewsEntity);
    }

    @Transactional
    public void getLatestNews() {
        NewsDataResponse newsDataResponse = restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/latest")
                        .queryParam("apikey", apiKey)
                        .queryParam("language", "fr")
                        .queryParam("country", "fr")
                        .queryParam("prioritydomain", "top")
                        .build())
                .retrieve()
                .body(NewsDataResponse.class);

        if (newsDataResponse == null || newsDataResponse.results().isEmpty()) {
            return;
        }

        List<NewsEntity> newsEntityList = newsDataResponse.results()
                .stream().map(this::toNewsEntity)
                .toList();

        newsRepository.saveAll(newsEntityList);
    }

    public List<News> findBookmarkNews(String uuid) {
        List<NewsEntity> newsEntityList = newsRepository.findByUserNews_User_UuidAndUserNews_Bookmarked(uuid, true);
        return newsEntityList.stream()
                .map(news -> newsMapper.toDto(news, uuid))
                .toList();
    }

    private NewsEntity toNewsEntity(NewsDataResult result) {
        NewsEntity newsEntity = NewsEntity.builder()
                .articleId(result.article_id())
                .link(result.link())
                .title(result.title())
                .description(result.description())
                .imageUrl(result.image_url())
                .publicationDate(result.pubDate())
                .sourceName(result.source_name())
                .sourceIcon(result.source_icon())
                .build();

        if (result.keywords() != null && !result.keywords().isEmpty()) {
            List<NewsKeywordsEntity> keywordsList = result.keywords().stream()
                    .map(keyword -> new NewsKeywordsEntity(null, newsEntity, keyword))
                    .toList();
            newsEntity.setKeywords(keywordsList);
        }

        if (result.category() != null && !result.category().isEmpty()) {
            List<NewsCategoriesEntity> categoriesList = result.category().stream()
                    .map(category -> new NewsCategoriesEntity(null, newsEntity, category))
                    .toList();
            newsEntity.setCategories(categoriesList);

        }

        if (result.country() != null && !result.country().isEmpty()) {
            List<NewsCountriesEntity> countriesList = result.country().stream()
                    .map(country -> new NewsCountriesEntity(null, newsEntity, country))
                    .toList();
            newsEntity.setCountries(countriesList);
        }

        return newsEntity;
    }

    private UserNewsEntity createOrUpdateUserNews(Long newsId, String uuid) {
        NewsEntity newsEntity = newsRepository.findById(newsId).orElseThrow((NewsNotFoundException::new));
        UserEntity userEntity = userRepository.findByUuid(uuid).orElseGet(() -> userService.create(uuid));

        return userNewsRepository.findByNews_IdAndUser(newsId, userEntity)
                .orElseGet(() -> {
                    UserNews userNews = new UserNews(null,
                            userMapper.toDto(userEntity),
                            newsMapper.toDto(newsEntity),
                            LocalDateTime.now()
                    );
                    return userNewsService.create(userNews);
                });
    }
}

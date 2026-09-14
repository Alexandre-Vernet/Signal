package com.avernet.signal.news;

import com.avernet.signal.config.GenericMapper;
import com.avernet.signal.news.news_categories.NewsCategoriesEntity;
import com.avernet.signal.news.news_countries.NewsCountriesEntity;
import com.avernet.signal.news.news_keywords.NewsKeywordsEntity;
import com.avernet.signal.user_news.UserNewsEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.time.LocalDateTime;

@Mapper(componentModel = "spring")
public interface NewsMapper extends GenericMapper<News, NewsEntity> {

    @Mapping(source = "news", target = ".")
    @Mapping(source = "bookmarked", target = "bookmarked")
    @Mapping(source = "readAt", target = "readAt")
    News toDto(UserNewsEntity userNewsEntity);

    @Mapping(target = "readAt", expression = "java(getReadAt(news, uuid))")
    @Mapping(target = "bookmarked", expression = "java(getBookmarked(news, uuid))")
    News toDto(NewsEntity news, String uuid);

    default String mapKeyword(NewsKeywordsEntity keywordsEntity) {
        return keywordsEntity.getKeyword();
    }

    default NewsKeywordsEntity mapKeywordEntity(String keyword) {
        NewsKeywordsEntity entity = new NewsKeywordsEntity();
        entity.setKeyword(keyword);
        return entity;
    }
    
    default String mapCategory(NewsCategoriesEntity newsCategoriesEntity) {
        return newsCategoriesEntity.getCategory();
    }

    default NewsCategoriesEntity mapCategoryEntity(String category) {
        NewsCategoriesEntity entity = new NewsCategoriesEntity();
        entity.setCategory(category);
        return entity;
    }
    
    default String mapCountry(NewsCountriesEntity newsCategoriesEntity) {
        return newsCategoriesEntity.getCountry();
    }

    default NewsCountriesEntity mapCountryEntity(String category) {
        NewsCountriesEntity entity = new NewsCountriesEntity();
        entity.setCountry(category);
        return entity;
    }

    default LocalDateTime getReadAt(NewsEntity news, String uuid) {
        return news.getUserNews().stream()
                .filter(u -> u.getUser().getUuid().equals(uuid))
                .map(UserNewsEntity::getReadAt)
                .findFirst()
                .orElse(null);
    }

    default boolean getBookmarked(NewsEntity news, String uuid) {
        return news.getUserNews().stream()
                .filter(u -> u.getUser().getUuid().equals(uuid))
                .map(UserNewsEntity::isBookmarked)
                .findFirst()
                .orElse(false);
    }
}

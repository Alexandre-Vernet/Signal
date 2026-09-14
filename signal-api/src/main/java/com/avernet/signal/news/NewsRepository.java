package com.avernet.signal.news;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NewsRepository extends JpaRepository<NewsEntity, Long> {
    List<NewsEntity> findDistinctByCategories_CategoryInOrderByPublicationDateDesc(List<String> category);

    List<NewsEntity> findByUserNews_User_UuidAndUserNews_Bookmarked(String uuid, boolean userNewsBookmarked);
}

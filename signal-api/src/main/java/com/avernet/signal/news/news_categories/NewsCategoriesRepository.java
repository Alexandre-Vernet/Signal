package com.avernet.signal.news.news_categories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface NewsCategoriesRepository extends JpaRepository<NewsCategoriesEntity, Long> {
    @Query("""
    SELECT DISTINCT n.category from NewsCategoriesEntity n order by n.category ASC
    """)
    List<String> findCategories();
}

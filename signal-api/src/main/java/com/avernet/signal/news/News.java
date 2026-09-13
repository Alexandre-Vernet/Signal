package com.avernet.signal.news;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
public class News {
    Long id;
    String articleId;
    String link;
    String title;
    String description;
    String imageUrl;
    List<String> keywords;
    List<String> categories;
    List<String> countries;
    LocalDateTime publicationDate;
    String sourceName;
    String sourceIcon;
    LocalDateTime readAt;
    boolean bookmarked;
}
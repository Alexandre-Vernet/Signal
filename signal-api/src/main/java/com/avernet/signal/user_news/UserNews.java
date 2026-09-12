package com.avernet.signal.user_news;

import com.avernet.signal.news.News;
import com.avernet.signal.user.User;

import java.time.LocalDateTime;

public record UserNews(
        Long id,
        User user,
        News news,
        LocalDateTime readAt
) {
}

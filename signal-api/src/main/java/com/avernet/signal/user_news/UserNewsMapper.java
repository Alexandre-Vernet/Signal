package com.avernet.signal.user_news;

import com.avernet.signal.config.GenericMapper;
import com.avernet.signal.news.NewsMapper;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", uses = NewsMapper.class)
public interface UserNewsMapper extends GenericMapper<UserNews, UserNewsEntity> {
}

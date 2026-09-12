package com.avernet.signal.user_news;

import com.avernet.signal.config.GenericMapper;
import com.avernet.signal.news.NewsMapper;
import com.avernet.signal.user.User;
import com.avernet.signal.user.UserEntity;
import com.avernet.signal.user.UserMapper;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", uses = NewsMapper.class)
public interface UserNewsMapper extends GenericMapper<UserNews, UserNewsEntity> {
}

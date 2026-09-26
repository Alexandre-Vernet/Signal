package com.avernet.signal.user_news;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserNewsService {

    private final UserNewsRepository userNewsRepository;
    private final UserNewsMapper userNewsMapper;

    @Transactional
    public UserNewsEntity create(UserNews userNews) {
        UserNewsEntity userNewsEntity = userNewsMapper.toEntity(userNews);
        return userNewsRepository.save(userNewsEntity);
    }
}

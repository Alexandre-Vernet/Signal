package com.avernet.signal.user_news;

import com.avernet.signal.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserNewsService {

    private final UserNewsRepository userNewsRepository;
    private final UserRepository userRepository;
    private final UserNewsMapper userNewsMapper;

    @Transactional
    UserNews create(UserNews userNews) {
        Long id = userRepository.findByUuid(userNews.user().getUuid()).getId();
        userNews.user().setId(id);
        
        UserNewsEntity userNewsEntity = userNewsMapper.toEntity(userNews);
        UserNewsEntity userNewsCreated = userNewsRepository.save(userNewsEntity);
        return userNewsMapper.toDto(userNewsCreated);
    }
}

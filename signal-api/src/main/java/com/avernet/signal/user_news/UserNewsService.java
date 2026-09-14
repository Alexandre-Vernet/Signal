package com.avernet.signal.user_news;

import com.avernet.signal.exception.ApiException;
import com.avernet.signal.exception.ErrorCodeEnum;
import com.avernet.signal.user.UserEntity;
import com.avernet.signal.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserNewsService {

    private final UserNewsRepository userNewsRepository;
    private final UserRepository userRepository;
    private final UserNewsMapper userNewsMapper;

    @Transactional
    public UserNewsEntity create(UserNews userNews) {
        UserEntity userEntity = userRepository.findByUuid(userNews.user().getUuid()).orElseThrow(() -> new ApiException(
                ErrorCodeEnum.USER_NOT_FOUND,
                "Cet utilisateur n'existe pas",
                HttpStatus.NOT_FOUND)
        );
        userNews.user().setId(userEntity.getId());

        UserNewsEntity userNewsEntity = userNewsMapper.toEntity(userNews);
        return userNewsRepository.save(userNewsEntity);
    }
}

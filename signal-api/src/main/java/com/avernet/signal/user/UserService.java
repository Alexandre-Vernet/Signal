package com.avernet.signal.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    @Transactional
    User create(User user) {
        user.setCreatedAt(LocalDateTime.now());
        UserEntity userEntity = userMapper.toEntity(user);
        UserEntity userCreated = userRepository.save(userEntity);
        return userMapper.toDto(userCreated);
    }
}

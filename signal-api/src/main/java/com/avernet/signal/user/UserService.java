package com.avernet.signal.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public UserEntity create(String uuid) {
        UserEntity userEntity = UserEntity.builder()
                .uuid(uuid)
                .createdAt(LocalDateTime.now())
                .build();
        return userRepository.save(userEntity);
    }
}

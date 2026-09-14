package com.avernet.signal.user_news;

import com.avernet.signal.user.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserNewsRepository extends JpaRepository<UserNewsEntity, Long> {
    Optional<UserNewsEntity> findByNews_IdAndUser(Long newsId, UserEntity user);
}

package com.avernet.signal.user;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class User{
        Long id;
        String uuid;
        LocalDateTime createdAt;
}

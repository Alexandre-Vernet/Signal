package com.avernet.signal.user;

import com.avernet.signal.config.GenericMapper;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper extends GenericMapper<User, UserEntity> {
}

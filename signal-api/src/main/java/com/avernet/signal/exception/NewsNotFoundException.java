package com.avernet.signal.exception;

import org.springframework.http.HttpStatus;

public class NewsNotFoundException extends ApiException {
    public NewsNotFoundException() {
        super(ErrorCodeEnum.NEWS_NOT_FOUND, "Cette actualité n'existe pas", HttpStatus.NOT_FOUND);
    }
}

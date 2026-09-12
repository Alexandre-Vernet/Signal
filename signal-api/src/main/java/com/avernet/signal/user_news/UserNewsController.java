package com.avernet.signal.user_news;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("user-news")
@RequiredArgsConstructor
public class UserNewsController {

    private final UserNewsService userNewsService;

    @PostMapping
    UserNews create(@RequestBody UserNews userNews) {
        return userNewsService.create(userNews);
    }
}

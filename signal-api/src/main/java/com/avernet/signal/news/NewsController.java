package com.avernet.signal.news;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("news")
@RequiredArgsConstructor
public class NewsController {

    private final NewsService newsService;

    @GetMapping
    public List<News> findAllNews(@RequestHeader(value = "X-User-UUID", required = false) String uuid) {
        return newsService.findAllNews(uuid);
    }
    
    @GetMapping("{id}")
    News getNews(@PathVariable Long id) {
        return newsService.getNews(id);
    }
    
    @GetMapping("{id}/image/publication-image")
    ResponseEntity<byte[]> getPublicationImage(@PathVariable Long id) {
        return newsService.getPublicationImage(id);
    }
    
    @GetMapping("{id}/image/source-icon")
    ResponseEntity<byte[]> getSourceIcon(@PathVariable Long id) {
        return newsService.getSourceIcon(id);
    }
    
    @GetMapping("categories")
    List<String> getCategories() {
        return newsService.getCategories();
    }

    @GetMapping("category")
    List<News> findByCategory(@RequestParam("category") List<String> category) {
        return newsService.findByCategory(category);
    }

    @PostMapping("{id}/read")
    News markNewsAsRead(@PathVariable Long id, @RequestHeader(value = "X-User-UUID") String uuid) {
        return newsService.markNewsAsRead(id, uuid);
    }

    @PostMapping("{id}/bookmark")
    News toggleBookmark(@PathVariable Long id, @RequestHeader(value = "X-User-UUID") String uuid) {
        return newsService.toggleBookmark(id, uuid);
    }
}

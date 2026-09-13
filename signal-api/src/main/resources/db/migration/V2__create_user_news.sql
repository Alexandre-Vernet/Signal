CREATE TABLE public.users
(
    id         bigserial               NOT NULL,
    uuid       varchar                 NOT NULL,
    created_at timestamp DEFAULT now() NOT NULL,
    CONSTRAINT users_pk PRIMARY KEY (id),
    CONSTRAINT users_unique UNIQUE (uuid)
);


CREATE TABLE public.user_news
(
    id      bigserial               NOT NULL,
    user_id bigserial               NOT NULL,
    news_id bigserial               NOT NULL,
    read_at timestamp NULL,
    is_bookmarked bool default false NOT NULL,
    CONSTRAINT user_news_pk PRIMARY KEY (id),
    CONSTRAINT user_news_unique UNIQUE (user_id,news_id),
    CONSTRAINT user_news_users_fk FOREIGN KEY (user_id) REFERENCES public.users (id),
    CONSTRAINT user_news_news_fk FOREIGN KEY (news_id) REFERENCES public.news (id)
);
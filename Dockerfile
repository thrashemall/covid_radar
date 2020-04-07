FROM registry.gitlab.com/alex.shilov.by/covid_radar:kernel-2.6.6

WORKDIR /app

COPY Gemfile* ./

RUN bundle install --jobs $(nproc) && \
    rm -rf ./vendor/bundle/ruby/*/cache/

COPY . .

RUN cp ./config/database.production.yml ./config/database.yml

CMD ["bundle", "exec"]

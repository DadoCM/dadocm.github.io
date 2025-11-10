FROM jekyll/jekyll:4

ENV TZ=America/New_York
ENV JEKYLL_ENV=production
ENV JEKYLL_CACHE_DIR=/tmp/.jekyll-cache

WORKDIR /code

COPY Gemfile* ./
RUN bundle install

COPY . /code

# Fix ownership so jekyll user can write
RUN chown -R jekyll:jekyll /code

# Switch to jekyll user to run build
USER jekyll

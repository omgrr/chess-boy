FROM ruby:2.4.7-stretch

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install git make gcc pkg-config autoconf && \
    apt-get -y install libpng16-16 libpng-dev libjpeg62-turbo libjpeg62-turbo-dev libwebp6 libwebp-dev libgomp1 libwebpmux2 libwebpdemux2 g++ && \
    git clone https://github.com/ImageMagick/ImageMagick.git && \
    cd ImageMagick && git checkout 7.0.8-56 && \
    ./configure && make && make install && \
    ldconfig /usr/local/lib && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /ImageMagick

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bin/run-boy-run"]

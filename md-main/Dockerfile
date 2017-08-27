FROM zzet/dreams:0.0.3

RUN mkdir /mydreams
WORKDIR /mydreams

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - \
        && apt-get install -y nodejs

COPY ./Gemfile /mydreams/Gemfile
COPY ./Gemfile.lock /mydreams/Gemfile.lock
RUN bundle install

COPY package.json /mydreams/package.json
RUN npm install

# #CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["tail", "-f", "/dev/random"]

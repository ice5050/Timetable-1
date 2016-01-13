FROM abevoelker/ruby:ruby-1.9.3-p551

# Install apt based dependencies required to run Rails as well as RubyGems.
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    libpq-dev

RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install the RubyGems.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the main application.
COPY . ./

EXPOSE 3000

CMD "rails server -b 0.0.0.0 -p 3000"

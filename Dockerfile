FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y build-essential

ENV APP_HOME /caze
RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD . $APP_HOME

# ENV settings
ENV GEM_HOME /gems
ENV BUNDLE_PATH $GEM_HOME
ENV PATH $GEM_HOME/bin:$PATH
ENV HISTFILE $APP_HOME/tmp/docker_histfile
ENV LANG C.UTF-8

# Config for the terminal
ADD .bashrc /root/.bashrc

RUN bundle check || bundle install -j4

CMD bundle exec rspec spec --color

FROM ruby:2.7.4-alpine

# By default image is built using RAILS_ENV=production.
# You may want to customize it:
#
#   --build-arg RAILS_ENV=development
#
# See https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#
ARG RAILS_ENV=production

# Devise requires secret key to be set during image build or it raises an error
# preventing from running any scripts.
# Users should override this variable by passing environment variable on container start.
ENV RAILS_ENV=${RAILS_ENV} \
    APP_HOME=/app \
    TZ=UTC \
    BUNDLER_VERSION=2.2.28 \
    USER_NAME=app

# Create group "app" and user "app".

RUN apk add --no-cache \
    curl \
    git \
    make \
    gcc \
    postgresql-dev \
    musl-dev \
    g++ \
    shared-mime-info \
    tzdata \
    ca-certificates

RUN addgroup -g 1000 -S ${USER_NAME} \
    && adduser -S -h ${APP_HOME} -s /sbin/nologin -G ${USER_NAME} -u 1000 ${USER_NAME}

USER ${USER_NAME}

RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR $APP_HOME

COPY --chown=${USER_NAME}:${USER_NAME} Gemfile Gemfile.lock .ruby-version ./

# Install dependencies
RUN bundle check || bundle install --jobs=$(nproc) --system --binstubs --without development test

# Copy the main application.
COPY --chown=${USER_NAME}:${USER_NAME} . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
COPY --chown=${USER_NAME}:${USER_NAME} config/docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]

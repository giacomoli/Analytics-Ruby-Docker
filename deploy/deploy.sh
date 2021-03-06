DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker network create property_analytics

# quick & dirty setup of the database without considering security since it is not necessary for this pet project
docker run --net property_analytics \
  --name statistics_db \
  --hostname statistics_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -d \
  postgres

docker build --tag property_analytics/statistics ${DIR}/../statistics
docker build --tag property_analytics/ui ${DIR}/../ui
docker build --tag property_analytics/crawl ${DIR}/../crawl

docker run --net property_analytics \
  --name statistics_app \
  --hostname statistics_app \
  --link statistics_db:statistics_db \
  -d \
  property_analytics/statistics

docker run --net property_analytics \
  --name ui \
  --hostname ui \
  -d \
  property_analytics/ui

docker run --net property_analytics \
  --name crawl \
  --hostname crawl \
  -d \
  property_analytics/crawl

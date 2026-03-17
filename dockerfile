FROM postman/newman

RUN npm install -g newman-reporter-html

WORKDIR /etc/newman/tests

COPY collections/ ./

RUN chmod +x run-tests.sh

ENTRYPOINT ["sh","run-tests.sh"]
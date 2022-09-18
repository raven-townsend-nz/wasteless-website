DROP TABLE IF EXISTS ADMINS CASCADE;
DROP TABLE IF EXISTS SALE_ITEM CASCADE;
DROP TABLE IF EXISTS INVENTORY_ITEM CASCADE;
DROP TABLE IF EXISTS PRODUCT_IMAGE CASCADE;
DROP TABLE IF EXISTS PRODUCT CASCADE;
DROP TABLE IF EXISTS BUSINESS CASCADE;
DROP TABLE IF EXISTS USER CASCADE;
DROP TABLE IF EXISTS ADDRESS CASCADE;
DROP TABLE IF EXISTS CARD_KEYWORDS CASCADE;
DROP TABLE IF EXISTS MARKETPLACE_KEYWORD CASCADE;
DROP TABLE IF EXISTS MARKETPLACE_CARD CASCADE;
DROP TABLE IF EXISTS SALE_LISTING_LIKE CASCADE;

CREATE TABLE ADDRESS
(
    ADDRESS_ID    INT AUTO_INCREMENT PRIMARY KEY,
    CITY          VARCHAR(255),
    COUNTRY       VARCHAR(255),
    POSTCODE      VARCHAR(255),
    REGION        VARCHAR(255),
    SUBURB        VARCHAR(255),
    STREET_NAME   VARCHAR(255),
    STREET_NUMBER VARCHAR(255)
);

CREATE TABLE USER
(
    USER_ID            INT AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME    VARCHAR(250) NOT NULL,
    MIDDLE_NAME   VARCHAR(250),
    LAST_NAME     VARCHAR(250) NOT NULL,
    NICKNAME      VARCHAR(250),
    BIO           VARCHAR(2000),
    EMAIL         VARCHAR(250) NOT NULL,
    DATE_OF_BIRTH DATE         NOT NULL,
    PHONE_NUMBER  VARCHAR(25),
    ADDRESS_ID    INT         NOT NULL,
    PASSWORD      VARCHAR(250),
    CREATED       DATE,
    ROLE          VARCHAR(250),
    FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS (ADDRESS_ID)
);

CREATE TABLE BUSINESS
(
    BUSINESS_ID       INT AUTO_INCREMENT PRIMARY KEY,
    BUSINESS_TYPE     VARCHAR(255) NOT NULL,
    DESCRIPTION       VARCHAR(2000),
    NAME              VARCHAR(250) NOT NULL,
    PRIMARY_ADMIN_ID  INT         NOT NULL,
    REGISTRATION_DATE DATE,
    ADDRESS_ID        INT         NOT NULL,
    FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS (ADDRESS_ID)
);

CREATE TABLE ADMINS
(
    USER_ID     INT NOT NULL,
    BUSINESS_ID INT NOT NULL,
    FOREIGN KEY (USER_ID) REFERENCEs USER (USER_ID),
    FOREIGN KEY (BUSINESS_ID) REFERENCES BUSINESS (BUSINESS_ID)
);

CREATE TABLE PRODUCT
(
    ROW_ID                   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PRODUCT_ID               VARCHAR(255),
    CREATED                  TIMESTAMP,
    DESCRIPTION              VARCHAR(255),
    MANUFACTURER             VARCHAR(255),
    NAME                     VARCHAR(255),
    RECOMMENDED_RETAIL_PRICE DOUBLE,
    BUSINESS_ID              INT,
    FOREIGN KEY (BUSINESS_ID) REFERENCES BUSINESS (BUSINESS_ID),
    UNIQUE (PRODUCT_ID, BUSINESS_ID)
);

CREATE TABLE PRODUCT_IMAGE
(
    PRODUCT_IMAGE_ID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FILENAME           VARCHAR(255),
    THUMBNAIL_FILENAME VARCHAR(255),
    IS_PRIMARY         BOOL,
    ROW_ID             INT,
    FOREIGN KEY (ROW_ID) REFERENCES PRODUCT (ROW_ID)
);

CREATE TABLE INVENTORY_ITEM
(
    INVENTORY_ITEM_ID  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BEST_BEFORE    DATE,
    SELL_BY        DATE,
    EXPIRES        DATE   NOT NULL,
    MANUFACTURED   VARCHAR(255),
    PRICE_PER_ITEM DOUBLE,
    QUANTITY       INTEGER,
    TOTAL_PRICE    DOUBLE,
    ROW_ID         INT,
    PRODUCT_ID     VARCHAR(255),
    BUSINESS_ID    INT,
    CREATED        DATETIME,
    FOREIGN KEY (BUSINESS_ID) REFERENCES BUSINESS (BUSINESS_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID)
);

CREATE TABLE SALE_ITEM
(
    SALE_ITEM_ID      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    INVENTORY_ITEM_ID INTEGER,
    QUANTITY          INTEGER,
    PRICE             DOUBLE,
    TOTAL_PRICE       DOUBLE,
    MORE_INFO         VARCHAR(255),
    SOLD              BOOL DEFAULT FALSE,
    CLOSES            DATE,
    CREATED           DATE,
    PURCHASED         DATE,
    PURCHASER_ID      INTEGER,
    FOREIGN KEY (INVENTORY_ITEM_ID) REFERENCES INVENTORY_ITEM (INVENTORY_ITEM_ID),
    FOREIGN KEY (PURCHASER_ID) REFERENCES USER (USER_ID)
);

CREATE TABLE SALE_LISTING_LIKE
(
    SALE_ITEM_ID INT NOT NULL,
    USER_ID INT NOT NULL,
    FOREIGN KEY (SALE_ITEM_ID) REFERENCES SALE_ITEM (SALE_ITEM_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER (USER_ID)
);

CREATE TABLE MARKETPLACE_KEYWORD
(
    MARKETPLACE_KEYWORD_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT ,
    NAME                   VARCHAR(255),
    CREATED                DATETIME
);

CREATE TABLE MARKETPLACE_CARD
(
    MARKETPLACE_CARD_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT ,
    CREATOR_ID          INT,
    SECTION             VARCHAR(255),
    CREATED             DATETIME,
    DISPLAY_PERIOD_END  DATETIME,
    TITLE               VARCHAR(255),
    DESCRIPTION         VARCHAR(2000),
    NOTIFIED_EXPIRING   BOOL DEFAULT FALSE,
    FOREIGN KEY (CREATOR_ID) REFERENCES USER (USER_ID)
);

CREATE TABLE CARD_KEYWORDS
(
    MARKETPLACE_CARD_ID    INT,
    MARKETPLACE_KEYWORD_ID INT,
    FOREIGN KEY (MARKETPLACE_CARD_ID) REFERENCES MARKETPLACE_CARD (MARKETPLACE_CARD_ID),
    FOREIGN KEY (MARKETPLACE_KEYWORD_ID) REFERENCES MARKETPLACE_KEYWORD (MARKETPLACE_KEYWORD_ID)
);
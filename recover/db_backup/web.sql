/*
 Navicat Premium Data Transfer

 Source Server         : sxb
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : localhost:3306
 Source Schema         : web

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 02/11/2023 14:44:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for artworks
-- ----------------------------
DROP TABLE IF EXISTS `artworks`;
CREATE TABLE `artworks`  (
  `pid` int(0) NOT NULL AUTO_INCREMENT,
  `uid` int(0) NULL DEFAULT NULL,
  `picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `likenum` int(0) NULL DEFAULT 0,
  `createtime` bigint(0) NULL DEFAULT NULL,
  `introduce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `view` bigint(0) NULL DEFAULT 0,
  `lastviewtime` bigint(0) NULL DEFAULT 0,
  PRIMARY KEY (`pid`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  CONSTRAINT `artworks_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of artworks
-- ----------------------------
INSERT INTO `artworks` VALUES (1, 14, '19350375_p0.jpg', '测试图片1', 0, 1691324987977, '', 58, 1698895473291);
INSERT INTO `artworks` VALUES (2, 14, '110459241_p0.png', '测试图片2', 0, 1691324987977, '这是一张测试图片', 81, 1698893964384);
INSERT INTO `artworks` VALUES (3, 14, '110459241_p1.png', '测试图片3', 1, 1691324987977, '', 34, 1698893975541);
INSERT INTO `artworks` VALUES (4, 14, '110459241_p2.png', '测试图片4', 0, 1691324987977, '', 24, 1698904945764);
INSERT INTO `artworks` VALUES (5, 14, '110459241_p3.png', '测试图片5', 0, 1691324987977, '', 8, 1698890805878);
INSERT INTO `artworks` VALUES (6, 15, '110459241_p4.png', '测试图片6', 0, 1691324987977, '', 6, 1698893967747);
INSERT INTO `artworks` VALUES (7, 14, '110459241_p5.png', '测试图片7', 0, 1691324987977, '', 12, 1698893979451);
INSERT INTO `artworks` VALUES (8, 15, '110459241_p6.png', '测试图片8', 3, 1691324987977, '', 137, 1698890815384);
INSERT INTO `artworks` VALUES (9, 16, '110459241_p7.png', '测试图片9', 0, 1691324987977, '', 16, 1698890914777);
INSERT INTO `artworks` VALUES (10, 18, 'background1.png', '测试图片10', 1, 1691324987977, '', 24, 1698893997123);
INSERT INTO `artworks` VALUES (11, 19, 'background2.png', '测试图片11', 0, 1691324987977, '', 10, 1693373090636);
INSERT INTO `artworks` VALUES (12, 14, 'background3.jpg', '测试图片12', 0, 1691324987977, '', 8, 1698897515228);
INSERT INTO `artworks` VALUES (13, 15, 'background4.jpg', '测试图片13', 0, 1691324987977, '', 0, 0);
INSERT INTO `artworks` VALUES (14, 15, 'background5.jpg', '测试图片14', 1, 1691324987977, '', 6, 1698890781923);
INSERT INTO `artworks` VALUES (15, 14, 'background6.png', '测试图片15', 0, 1691324987977, '', 9, 1698895196259);
INSERT INTO `artworks` VALUES (16, 17, 'BC8F1E1FC54254D7EBC34548D9D899CD.png', '测试图片16', 2, 1691324987977, '', 31, 1698897399343);
INSERT INTO `artworks` VALUES (17, 19, 'EV_SP01.png', '测试图片17', 0, 1691324987977, '', 3, 1698802858375);
INSERT INTO `artworks` VALUES (18, 18, 'EV_SP04.png', '测试图片18', 0, 1691324987977, '', 5, 1698906590632);
INSERT INTO `artworks` VALUES (19, 15, 'IMG_0033(20220828-205125).JPG', '测试图片19', 2, 1691324987977, '', 12, 1698890499168);
INSERT INTO `artworks` VALUES (20, 16, 'IMG_0346(20230807-235117).JPG', '测试图片20', 1, 1691324987977, '', 14, 1698895667867);
INSERT INTO `artworks` VALUES (21, 19, 'IMG_0360(20230807-235117).JPG', '测试图片21', 2, 1691324987977, '', 20, 1698897492926);
INSERT INTO `artworks` VALUES (22, 17, 'IMG_1114(20211108-170001).JPG', '测试图片22', 0, 1691324987977, '', 6, 0);
INSERT INTO `artworks` VALUES (23, 16, 'IMG_1115.PNG', '测试图片23', 2, 1691324987977, '', 12, 1698827726851);
INSERT INTO `artworks` VALUES (24, 17, 'IMG_1116(20211108-173633).JPG', '测试图片24', 0, 1691324987977, '', 4, 1698897359812);
INSERT INTO `artworks` VALUES (25, 15, 'IMG_1406(20220828-205126).JPG', '测试图片25', 0, 1691324987977, '', 4, 1698574459521);
INSERT INTO `artworks` VALUES (26, 15, 'IMG_3407.JPG', '测试图片26', 0, 1691324987977, '', 1, 0);
INSERT INTO `artworks` VALUES (27, 20, 'IMG_3409.PNG', '测试图片27', 1, 1691324987977, '', 10, 1698897416101);
INSERT INTO `artworks` VALUES (28, 20, 'IMG_4177(20230621-150307).JPG', '测试图片28', 0, 1691324987977, '', 5, 1698802484338);
INSERT INTO `artworks` VALUES (29, 20, 'IMG_4221.JPG', '测试图片29', 0, 1691324987977, '', 8, 1698897525900);
INSERT INTO `artworks` VALUES (30, 18, 'IMG_4234.PNG', '测试图片30', 0, 1691324987977, '', 11, 1698897507937);
INSERT INTO `artworks` VALUES (31, 16, 'IMG_4241(20230621-150307).JPG', '测试图片31', 0, 1691324987977, '', 1, 1691717997506);
INSERT INTO `artworks` VALUES (32, 18, 'IMG_4242(20230621-150307).JPG', '测试图片32', 0, 1691324987977, '', 5, 1698827747042);
INSERT INTO `artworks` VALUES (33, 19, 'IMG_4307(20230809-175426).JPG', '测试图片33', 2, 1691324987977, '', 6, 1697886561553);
INSERT INTO `artworks` VALUES (38, 14, 'SG0_EV057A.png', '测试图片35', 0, 1691809133649, '这是测试图片', 2, 1698827711261);
INSERT INTO `artworks` VALUES (39, 26, 'c738b241-9e86-433e-926e-492463fe0976_404.jpg', '测试图片36', 3, 1698800676008, '404页面', 27, 1698904240695);

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `uid` int(0) NOT NULL,
  `pid` int(0) NOT NULL,
  `favoritetime` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`uid`, `pid`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `artworks` (`pid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (14, 10, 1698755308729);
INSERT INTO `favorite` VALUES (14, 14, 1697963288956);
INSERT INTO `favorite` VALUES (14, 16, 1698893221444);
INSERT INTO `favorite` VALUES (14, 19, 1698750425957);
INSERT INTO `favorite` VALUES (14, 21, 1691808069045);
INSERT INTO `favorite` VALUES (14, 27, 1691840085550);
INSERT INTO `favorite` VALUES (14, 33, 1693373540120);
INSERT INTO `favorite` VALUES (14, 39, 1698800847368);
INSERT INTO `favorite` VALUES (15, 8, 1691673218145);
INSERT INTO `favorite` VALUES (15, 16, 1698800964599);
INSERT INTO `favorite` VALUES (15, 20, 1698894024317);
INSERT INTO `favorite` VALUES (15, 21, 1691728469721);
INSERT INTO `favorite` VALUES (15, 23, 1691728508047);
INSERT INTO `favorite` VALUES (15, 39, 1698800893352);
INSERT INTO `favorite` VALUES (16, 8, 1691728538286);
INSERT INTO `favorite` VALUES (16, 23, 1691728544017);
INSERT INTO `favorite` VALUES (16, 33, 1691728548774);
INSERT INTO `favorite` VALUES (23, 3, 1692102269463);
INSERT INTO `favorite` VALUES (23, 8, 1692101997914);
INSERT INTO `favorite` VALUES (23, 19, 1692102007054);
INSERT INTO `favorite` VALUES (26, 39, 1698800829335);

-- ----------------------------
-- Table structure for follow
-- ----------------------------
DROP TABLE IF EXISTS `follow`;
CREATE TABLE `follow`  (
  `uid` int(0) NOT NULL,
  `fan` int(0) NOT NULL,
  PRIMARY KEY (`uid`, `fan`) USING BTREE,
  INDEX `fan`(`fan`) USING BTREE,
  CONSTRAINT `follow_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `follow_ibfk_2` FOREIGN KEY (`fan`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of follow
-- ----------------------------
INSERT INTO `follow` VALUES (15, 14);
INSERT INTO `follow` VALUES (16, 14);
INSERT INTO `follow` VALUES (17, 14);
INSERT INTO `follow` VALUES (18, 14);
INSERT INTO `follow` VALUES (19, 14);
INSERT INTO `follow` VALUES (20, 14);
INSERT INTO `follow` VALUES (23, 14);
INSERT INTO `follow` VALUES (26, 14);
INSERT INTO `follow` VALUES (27, 14);
INSERT INTO `follow` VALUES (14, 15);
INSERT INTO `follow` VALUES (14, 16);
INSERT INTO `follow` VALUES (14, 17);
INSERT INTO `follow` VALUES (14, 18);
INSERT INTO `follow` VALUES (14, 19);
INSERT INTO `follow` VALUES (14, 20);
INSERT INTO `follow` VALUES (14, 23);
INSERT INTO `follow` VALUES (18, 23);
INSERT INTO `follow` VALUES (14, 26);
INSERT INTO `follow` VALUES (14, 27);
INSERT INTO `follow` VALUES (14, 28);

-- ----------------------------
-- Table structure for history
-- ----------------------------
DROP TABLE IF EXISTS `history`;
CREATE TABLE `history`  (
  `uid` int(0) NOT NULL,
  `pid` int(0) NOT NULL,
  `viewtime` bigint(0) NOT NULL,
  PRIMARY KEY (`uid`, `pid`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `artworks` (`pid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of history
-- ----------------------------
INSERT INTO `history` VALUES (14, 4, 1698904946708);
INSERT INTO `history` VALUES (14, 12, 1698897516162);
INSERT INTO `history` VALUES (14, 16, 1698897400282);
INSERT INTO `history` VALUES (14, 18, 1698906591580);
INSERT INTO `history` VALUES (14, 21, 1698897493862);
INSERT INTO `history` VALUES (14, 27, 1698897417038);
INSERT INTO `history` VALUES (14, 29, 1698897526861);
INSERT INTO `history` VALUES (14, 30, 1698897508880);
INSERT INTO `history` VALUES (14, 39, 1698904241586);
INSERT INTO `history` VALUES (15, 2, 1698893965272);
INSERT INTO `history` VALUES (15, 3, 1698893976413);
INSERT INTO `history` VALUES (15, 6, 1698893968636);
INSERT INTO `history` VALUES (15, 7, 1698893980339);
INSERT INTO `history` VALUES (15, 10, 1698893998070);
INSERT INTO `history` VALUES (15, 15, 1698894088481);
INSERT INTO `history` VALUES (15, 20, 1698894018699);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `uid` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `admin` int(0) NOT NULL DEFAULT 0,
  `createtime` bigint(0) NOT NULL,
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE INDEX `unique_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (14, 'admin', '8520', 1, 1691324987977);
INSERT INTO `user` VALUES (15, 'user01', '753951', 0, 1691325003195);
INSERT INTO `user` VALUES (16, 'user02', '951753', 0, 1691325017426);
INSERT INTO `user` VALUES (17, 'user04', '778899', 0, 1691413049911);
INSERT INTO `user` VALUES (18, 'user05', 'qwerty', 0, 1691474989194);
INSERT INTO `user` VALUES (19, 'user06', 'password', 0, 1691502422360);
INSERT INTO `user` VALUES (20, 'user07', '445566', 0, 1691648729682);
INSERT INTO `user` VALUES (23, 'user08', '20020813', 0, 1692101813418);
INSERT INTO `user` VALUES (26, 'user09', '885522', 0, 1698746652566);
INSERT INTO `user` VALUES (27, 'user10', '885522', 0, 1698746939938);
INSERT INTO `user` VALUES (28, 'user11', '885522', 0, 1698751678574);

-- ----------------------------
-- Table structure for userinfo
-- ----------------------------
DROP TABLE IF EXISTS `userinfo`;
CREATE TABLE `userinfo`  (
  `iid` int(0) NOT NULL,
  `background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `userimage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `nickname` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `self` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sex` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `birthday` bigint(0) NULL DEFAULT NULL,
  `email` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`iid`) USING BTREE,
  CONSTRAINT `userinfo_ibfk_1` FOREIGN KEY (`iid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of userinfo
-- ----------------------------
INSERT INTO `userinfo` VALUES (14, 'admin.png', 'admin.jpg', 'admin', 'VuePictures的开发,测试，维护人员', 'men', 1029168000000, '1277820742@qq.com');
INSERT INTO `userinfo` VALUES (15, '9c4c31dc-755e-4b3a-aaa8-7487d978dac2_IMG_1116(20211108-173633).JPG', '4b434912-c4e4-4caf-bf40-21d78feef48f_65a5ca56-0129-4c62-835d-590e2870e116_IMG_4624.JPG', '测试用户1', '我是测试用户哦', 'women', 1691251200000, 'test@qq.com');
INSERT INTO `userinfo` VALUES (16, '3293fe07-102c-4129-9a05-43479f4c0e26_EV_SP04.png', '84d92a6b-197b-4602-bc08-64942dd238f2_79ecbb33-a591-441d-98da-6eb2332d59b2_IMG_4625.jpg', '测试用户2', '我也是测试用户啊', 'men', 1565654400000, 'test@qq.com');
INSERT INTO `userinfo` VALUES (17, '110459241_p0.png', 'fe36e183-7592-4673-b43e-721ce52fb7ae_IMG_4623.JPG', '测试用户4', '我是测试用户！', 'men', 1692144000000, 'none');
INSERT INTO `userinfo` VALUES (18, 'default.png', 'd0daeb2c-ba70-4f8f-99c1-5ae4af87906e_IMG_4622.JPG', '测试用户5', '我~也是测试用户？', 'men', 1691424000000, 'none');
INSERT INTO `userinfo` VALUES (19, 'default.png', '741e7d69-b880-45d6-a54c-b60b2d2191c4_110621896_p0_master1201.jpg', '测试用户6', '我我我！也是测试账号', 'women', 1691424000000, 'none');
INSERT INTO `userinfo` VALUES (20, 'default.png', 'default.png', 'User', '这个人很懒，没有个人简介哦', 'none', 1691648729682, 'none');
INSERT INTO `userinfo` VALUES (23, '110459241_p1.png', '2e461c35-3d4d-479f-9aef-2a6a8cddc181_A7B23E7AC40DBBC8F07F6129F0A45795.png', '测试用户8', '我是测试用户！', 'men', 1029196800000, 'test@mail.com');
INSERT INTO `userinfo` VALUES (26, 'default.png', 'default.png', 'User', '这个人很懒，没有个人简介哦', 'none', 1698746652566, 'ss_ymbol@outlook.com');
INSERT INTO `userinfo` VALUES (27, 'default.png', 'default.png', 'User', '这个人很懒，没有个人简介哦', 'none', 1698746939938, '1277820742@qq.com');
INSERT INTO `userinfo` VALUES (28, 'default.png', 'default.png', 'User', '这个人很懒，没有个人简介哦', 'none', 1698751678574, '3280098956@qq.com');

SET FOREIGN_KEY_CHECKS = 1;

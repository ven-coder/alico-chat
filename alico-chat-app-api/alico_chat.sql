/*
 Navicat Premium Data Transfer

 Source Server         : localmysql
 Source Server Type    : MySQL
 Source Server Version : 50741 (5.7.41)
 Source Host           : localhost:3306
 Source Schema         : alico_chat

 Target Server Type    : MySQL
 Target Server Version : 50741 (5.7.41)
 File Encoding         : 65001

 Date: 11/04/2024 21:01:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for oc_account_logout
-- ----------------------------
DROP TABLE IF EXISTS `oc_account_logout`;
CREATE TABLE `oc_account_logout`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `case_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '注销单号',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注销用户id',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0提交中 1已注销  2撤销',
  `review_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '处理时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity`;
CREATE TABLE `oc_activity`  (
  `activity_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `activity_classify_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '节目分类ID',
  `activity_classify_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '节目分类名称',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `label_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '标签ID',
  `label_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签code',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签名',
  `object_classify_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '期望对象ID',
  `object_classify_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '期望对象',
  `location_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '城市ID',
  `location_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '城市名',
  `position_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '定位城市',
  `activity_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动时间 0代表不限制',
  `date_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '约会时间范围',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '附件',
  `images_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片数量',
  `is_comment` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0允许评论 1不允许',
  `is_hidden` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '同性隐藏 0不隐藏 1隐藏',
  `allow_sex` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '允许查看的性别 0不限制 1男 2女',
  `sex` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户性别',
  `is_finish` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否完成 针对节目',
  `finish_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  `like_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `apply_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '报名数',
  `activity_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动类型 0节目 1动态',
  `operator_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预操作用户ID',
  `audit` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认0 审核中 1审核通过 2审核未通过 3复审',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态 0显示 1隐藏',
  `is_deleted` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除 1已删除',
  `weight` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序值',
  `recommend_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '推荐时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`activity_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '约节目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_classify
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_classify`;
CREATE TABLE `oc_activity_classify`  (
  `activity_classify_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `classify_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '节目名称',
  `classify_icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '节目logo',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0显示 1不显示',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`activity_classify_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '节目分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_comment
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_comment`;
CREATE TABLE `oc_activity_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `to_user_id` int(11) NOT NULL DEFAULT 0 COMMENT '接收用户ID',
  `activity_id` int(11) NOT NULL DEFAULT 0 COMMENT '活动ID',
  `activity_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '活动类型',
  `comment_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '评论类型',
  `comment_user_id` int(11) NOT NULL DEFAULT 0 COMMENT '评论者ID',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `created_at` int(10) NOT NULL DEFAULT 0,
  `updated_at` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动评论' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_label
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_label`;
CREATE TABLE `oc_activity_label`  (
  `label_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `label_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签名',
  `label_icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `label_weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `label_status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0显示 1隐藏',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动标签' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_like
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_like`;
CREATE TABLE `oc_activity_like`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动点赞表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_report
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_report`;
CREATE TABLE `oc_activity_report`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `activity_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动ID',
  `activity_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动用户ID',
  `reason_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '问题ID',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '举报原因',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '补充说明',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '举报时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动匿名举报' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_activity_sign
-- ----------------------------
DROP TABLE IF EXISTS `oc_activity_sign`;
CREATE TABLE `oc_activity_sign`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `activity_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动ID',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_admin
-- ----------------------------
DROP TABLE IF EXISTS `oc_admin`;
CREATE TABLE `oc_admin`  (
  `admin_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话',
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `login_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0正常 1禁用',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`admin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_admin_access
-- ----------------------------
DROP TABLE IF EXISTS `oc_admin_access`;
CREATE TABLE `oc_admin_access`  (
  `admin_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`admin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理角色授权表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_admin_log`;
CREATE TABLE `oc_admin_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客服真实姓名',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '访问路由',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'GET POST',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作说明',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作数据',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作IP',
  `agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '浏览器标识',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `oc_admin_menu`;
CREATE TABLE `oc_admin_menu`  (
  `menu_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日志标题',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日志备注',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0菜单 1功能',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `oc_admin_role`;
CREATE TABLE `oc_admin_role`  (
  `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_pid` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `routes_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_album
-- ----------------------------
DROP TABLE IF EXISTS `oc_album`;
CREATE TABLE `oc_album`  (
  `picture_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片路径',
  `media_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '媒体类型 0照片 1视频',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `is_burn` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否阅后即焚 1是 0否',
  `is_fee` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否收费 1收费',
  `label` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '标签 1真人 2女神 3本人',
  `audit` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认0 审核中 1审核通过 2审核不通过 3复审',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `match_socre` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '匹配分数值',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`picture_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册图库表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_album_confirm
-- ----------------------------
DROP TABLE IF EXISTS `oc_album_confirm`;
CREATE TABLE `oc_album_confirm`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送用户id',
  `to_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '接收用户ID',
  `picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发送图片',
  `is_burned` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否焚毁',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0待审核 1通过 2拒绝',
  `burn_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '焚毁时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '申请时间',
  `check_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册发送图片申请' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_album_recycle
-- ----------------------------
DROP TABLE IF EXISTS `oc_album_recycle`;
CREATE TABLE `oc_album_recycle`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `picture_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片路径',
  `media_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '媒体类型 0照片 1视频',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `is_burn` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否阅后即焚 1是 0否',
  `is_fee` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否收费 1收费',
  `label` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '标签 1真人 2女神 3本人',
  `audit` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认0 审核中 1审核通过 2审核不通过 3复审',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `match_socre` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '匹配分数值',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册图库回收站' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_album_view
-- ----------------------------
DROP TABLE IF EXISTS `oc_album_view`;
CREATE TABLE `oc_album_view`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NULL DEFAULT 0,
  `picture_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '解锁图片',
  `picture_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相册的用户ID',
  `type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0阅后即焚 1付费解锁',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册焚毁' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_apple_pay_sandbox
-- ----------------------------
DROP TABLE IF EXISTS `oc_apple_pay_sandbox`;
CREATE TABLE `oc_apple_pay_sandbox`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `amount` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '苹果沙箱充值记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_arc_soft_real_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_arc_soft_real_record`;
CREATE TABLE `oc_arc_soft_real_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `face_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '人脸图片',
  `real_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '真人图片',
  `match_score` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '匹配分数',
  `created_at` int(10) NOT NULL DEFAULT 0,
  `updated_at` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '人脸比对记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_audit_log`;
CREATE TABLE `oc_audit_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `audit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '审核ID',
  `activity_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '节目名称',
  `audit_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核类型 1头像   2照片 3视频 4真人 5女神  6节目 7动态',
  `operator_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作者ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `review` tinyint(4) NOT NULL COMMENT '审核',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核状态： 0 未通过 1通过',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审核操作日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_carousel
-- ----------------------------
DROP TABLE IF EXISTS `oc_carousel`;
CREATE TABLE `oc_carousel`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '打开网址',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序值',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0显示 1隐藏',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发布时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '电台轮播图' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_custom_config
-- ----------------------------
DROP TABLE IF EXISTS `oc_custom_config`;
CREATE TABLE `oc_custom_config`  (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置选项',
  `value_format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '值格式',
  `authority` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0公开 1鉴权 2私有',
  `admin_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作者id',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '生成时间',
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`, `key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自定义配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_desired_object
-- ----------------------------
DROP TABLE IF EXISTS `oc_desired_object`;
CREATE TABLE `oc_desired_object`  (
  `object_classify_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `object_classify_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '期望类型',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0禁用 1启用',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`object_classify_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '期望对象' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_distribution_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_distribution_record`;
CREATE TABLE `oc_distribution_record`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `suggested_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '推荐用户ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分销记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_distribution_user
-- ----------------------------
DROP TABLE IF EXISTS `oc_distribution_user`;
CREATE TABLE `oc_distribution_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话号码',
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码盐',
  `role` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分销角色：1内部运营 2外部分销',
  `level` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分销等级 内部1级  外部1级2级',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `belongs_to` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '归属上级ID 默认为 0无上级',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '专属推荐码',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户状态  1正常 2删除',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分销主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_feedback_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_feedback_log`;
CREATE TABLE `oc_feedback_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `created_at` int(10) NULL DEFAULT 0,
  `updated_at` int(10) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_gold_package
-- ----------------------------
DROP TABLE IF EXISTS `oc_gold_package`;
CREATE TABLE `oc_gold_package`  (
  `gold_package_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `gold_num` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币数量',
  `price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `original_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '原价',
  `pay_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付编码',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `device` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '设备类型 0安卓 1苹果',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`gold_package_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '金币配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_greet_female
-- ----------------------------
DROP TABLE IF EXISTS `oc_greet_female`;
CREATE TABLE `oc_greet_female`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '推荐女性' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_invitation
-- ----------------------------
DROP TABLE IF EXISTS `oc_invitation`;
CREATE TABLE `oc_invitation`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '申请者ID',
  `consumer_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用者ID',
  `operator_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作用户ID',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消费者手机号',
  `source` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户来源 1新用户注册 2老用户邀请 3运营邀请',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所在地',
  `channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '信息渠道',
  `wechat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '微信号',
  `recommender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '推荐人',
  `grade` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认普通邀请码 1超级邀请码',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态： 0待处理 1已发放 2已拒绝',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '邀请码申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_like_user
-- ----------------------------
DROP TABLE IF EXISTS `oc_like_user`;
CREATE TABLE `oc_like_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `like_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '喜欢的用户ID',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户喜欢表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_location
-- ----------------------------
DROP TABLE IF EXISTS `oc_location`;
CREATE TABLE `oc_location`  (
  `location_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `location_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '位置名称(省/市)',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `level` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '等级 0省份 1城市',
  `city_code` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '城市code关联百度地图',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1禁用 默认启用',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`location_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '区域设置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_msg_type
-- ----------------------------
DROP TABLE IF EXISTS `oc_msg_type`;
CREATE TABLE `oc_msg_type`  (
  `msg_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消息类型名',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`msg_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统消息类型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_oauths
-- ----------------------------
DROP TABLE IF EXISTS `oc_oauths`;
CREATE TABLE `oc_oauths`  (
  `oauth_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `oauth_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0微信 1qq 3微博',
  `oauth_unionid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台唯一ID',
  `oauth_openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '应用唯一ID',
  `access_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'token凭证',
  `refresh_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '刷新token',
  `token_expire` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'token过期时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`oauth_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '第三方授权登录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order
-- ----------------------------
DROP TABLE IF EXISTS `oc_order`;
CREATE TABLE `oc_order`  (
  `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户手机',
  `order_amount` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `order_gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单使用的颜值币',
  `order_status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单状态 -1已取消 0待支付 1已支付 2已退款',
  `pay_channel` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付方式1微信 2支付宝 3余额 4颜值币 5appstore',
  `pay_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付时间',
  `trade_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '第三方支付订单',
  `agent` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1安卓 2iOS',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '下单时间',
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_activity
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_activity`;
CREATE TABLE `oc_order_activity`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `activity_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动类型',
  `activity_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联活动ID',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0未生效 1已生效',
  `use_status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否使用 0未使用 1已使用',
  `release_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '付费发布活动' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_album
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_album`;
CREATE TABLE `oc_order_album`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `unlock_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被解锁相册用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '解锁相册查看权限' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_contact
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_contact`;
CREATE TABLE `oc_order_contact`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `unlock_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '解锁用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '解锁联系方式(非VIP)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_coupon`;
CREATE TABLE `oc_order_coupon`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `send_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送者',
  `to_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '接收者',
  `currency_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '货币类型 0金钱 1虚拟币',
  `money` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `recv_status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0待领取 1已领取 2已过期',
  `recv_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '处理时间',
  `send_status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否生效 取决是否支付 0未生效 1已生效',
  `entry_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '生效时间',
  `expire_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '过期时间',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '红包表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_gold
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_gold`;
CREATE TABLE `oc_order_gold`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `gold_package_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币套餐ID',
  `price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `gold_num` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '充值数量',
  `pay_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '金币充值表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_picture
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_picture`;
CREATE TABLE `oc_order_picture`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `picture_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片ID',
  `picture_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '付费图片' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_product
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_product`;
CREATE TABLE `oc_order_product`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '产品名',
  `product_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '产品描述',
  `product_quantity` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '数量',
  `product_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '商品单价',
  `product_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '产品类型 1vip充值 2金币充值 3解锁相册 4红包相册 5解锁联系 6发节目 7发动态 8金币红包 9现金红包',
  `product_gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '颜值币',
  `product_fee_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '费用类型 0金钱 1虚拟币',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单产品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_type
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_type`;
CREATE TABLE `oc_order_type`  (
  `order_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单类型',
  PRIMARY KEY (`order_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单产品类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_order_vip
-- ----------------------------
DROP TABLE IF EXISTS `oc_order_vip`;
CREATE TABLE `oc_order_vip`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单号',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `package_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联vip套餐ID',
  `package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'vip套餐名',
  `package_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '会员套餐价格',
  `package_day` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '天数',
  `expire_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0永久会员  1有限期会员',
  `package_gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币数',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否充值 1已充值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单VIP充值' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_pay_result_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_pay_result_record`;
CREATE TABLE `oc_pay_result_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_method` tinyint(4) NOT NULL DEFAULT 0 COMMENT '支付方式',
  `out_trade_no` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内部交易单号',
  `trade_no` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '外部交易单号',
  `client_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'IP地址',
  `body` json NULL COMMENT '数据包',
  `created_at` int(10) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` int(10) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付结果记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_pay_token
-- ----------------------------
DROP TABLE IF EXISTS `oc_pay_token`;
CREATE TABLE `oc_pay_token`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付凭据',
  `chan` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '渠道',
  `create_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uq`(`token`, `chan`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_profession
-- ----------------------------
DROP TABLE IF EXISTS `oc_profession`;
CREATE TABLE `oc_profession`  (
  `profession_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `profession_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '职业分类名称',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1禁用 默认启用',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`profession_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '职业配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_report_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_report_record`;
CREATE TABLE `oc_report_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT '活动ID',
  `report_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '举报类型',
  `report_user_id` int(11) NOT NULL DEFAULT 0 COMMENT '被投诉用户ID',
  `body` json NOT NULL COMMENT '明细',
  `created_at` int(10) NULL DEFAULT NULL,
  `updated_at` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '投诉表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_review_attach_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_review_attach_record`;
CREATE TABLE `oc_review_attach_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `review_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '审核类型',
  `media_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '媒体类型',
  `sex` tinyint(4) NOT NULL COMMENT '性别',
  `review_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '审核状态',
  `body` json NULL COMMENT '审核数据',
  `created_at` int(10) NULL DEFAULT 0,
  `updated_at` int(10) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审核表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_rong_cloud_user
-- ----------------------------
DROP TABLE IF EXISTS `oc_rong_cloud_user`;
CREATE TABLE `oc_rong_cloud_user`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ry_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '融云用户ID',
  `ry_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'token',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '融云用户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_sys_message
-- ----------------------------
DROP TABLE IF EXISTS `oc_sys_message`;
CREATE TABLE `oc_sys_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消息类型',
  `msg_type_id` int(11) NOT NULL DEFAULT 0 COMMENT '消息ID',
  `msg_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '消息标题',
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `ry_send_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'ry用户ID',
  `to_user_id` int(11) NOT NULL DEFAULT 0 COMMENT '接收用户ID',
  `ry_recv_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '接收ry用户ID',
  `msg_time` int(11) NOT NULL DEFAULT 0 COMMENT '消息时间',
  `body` json NULL COMMENT '消息内容',
  `read` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否读取',
  `created_at` int(10) NOT NULL DEFAULT 0,
  `updated_at` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统消息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_system_config
-- ----------------------------
DROP TABLE IF EXISTS `oc_system_config`;
CREATE TABLE `oc_system_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `class` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '配置类 1内容配置 2自动回复配置  3敏感词库配置',
  `type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '类型',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态 1正常 2禁用',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_system_config_type
-- ----------------------------
DROP TABLE IF EXISTS `oc_system_config_type`;
CREATE TABLE `oc_system_config_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态',
  `created_at` int(10) NOT NULL DEFAULT 0,
  `updated_at` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置类型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user
-- ----------------------------
DROP TABLE IF EXISTS `oc_user`;
CREATE TABLE `oc_user`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `sex` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0保密 1男 2女',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码扰乱码',
  `album_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相册数量',
  `online` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0离线 1在线',
  `last_online` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后上线时间',
  `vip` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否会员 0不是会员 1是会员',
  `vip_expire_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员过期时间',
  `list_hide` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户主动设置隐藏 0不隐藏 1隐藏',
  `real` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '真人验证 默认0未验证 1通过真人验证',
  `is_consumers` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否付费用户 默认0:不是 1:是',
  `goddess` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '女神验证 默认0未验证 1通过女神验证',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '-1注册未完成 0注册完成 1冻结',
  `is_robot` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `is_shield` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否屏蔽 0否 1是',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设备id',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_blacklist`;
CREATE TABLE `oc_user_blacklist`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `black_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被拉黑用户ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '拉黑时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户自定义黑名单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_code
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_code`;
CREATE TABLE `oc_user_code`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `invitation_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '申请记录ID',
  `consumer_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用者ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邀请码',
  `grade` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认普通邀请码 1超级邀请码',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联上一级code',
  `generate` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 before 1 after',
  `quantity` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '邀请码数量',
  `expire_in` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0不限时间 或 overdue_time-beg_time',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态：0未使用 1已使用 2已过期',
  `beg_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始时间',
  `overdue_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '过期时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '邀请码表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_device
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_device`;
CREATE TABLE `oc_user_device`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `agent` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1安卓 2iOS',
  `agent_model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机型号',
  `agent_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '设备版本',
  `app_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'app版本',
  `last_login_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登入时间',
  `last_login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后登入IP',
  `unique_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机唯一编码',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '第一次登入时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户登录使用的设备' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_evaluate`;
CREATE TABLE `oc_user_evaluate`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `male_courtesy` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '礼貌',
  `male_interest` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '有趣',
  `male_generous` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '大方',
  `male_refreshed` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '爽快',
  `male_mouth_high` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '口嗨',
  `male_unfriendly` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '不友好',
  `female_friendly` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '友好',
  `female_interest` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '有趣',
  `female_refreshed` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '爽快',
  `female_patience` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '耐心',
  `female_aloof` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '高冷',
  `female_short_fuse` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '暴脾气',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_evaluate_record
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_evaluate_record`;
CREATE TABLE `oc_user_evaluate_record`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发起评价用户',
  `eval_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被评价用户',
  `label_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签类型',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签名称',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户评论记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_freeze
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_freeze`;
CREATE TABLE `oc_user_freeze`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `freeze_length` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '冻结时长 eg：3天',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '冻结原因',
  `freeze_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '冻结时间',
  `unfreeze_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '解冻时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户冻结表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_info
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_info`;
CREATE TABLE `oc_user_info`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `birthday` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '生日',
  `wechat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '微信',
  `qq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'qq',
  `height` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '身高',
  `weight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '体重',
  `describe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '个人说明',
  `profession_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '职业ID',
  `profession` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '职业',
  `live_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '城市',
  `live_city_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '城市ID',
  `act_clas_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动分类',
  `act_clas_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动分类ID',
  `pass` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户来源 0自己邀请码 1别人邀请码 2会员',
  `object_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '期望对象',
  `object_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '期望对象ID',
  `hide_contact` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '隐藏社交账号 默认隐藏 1不隐藏',
  `active_contact` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1完善社交',
  `invite_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邀请码',
  `device` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1安卓 2ios',
  `label` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户资料' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_location
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_location`;
CREATE TABLE `oc_user_location`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `longitude` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '经度',
  `latitude` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '纬度',
  `geo_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'geohash',
  `location_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '定位城市ID  未关联0',
  `location_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '定位城市',
  `first_city_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '首次城市ID',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '省份',
  `district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '街道',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详情地址',
  `zip_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮编',
  `ip_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'ip地址',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户lbs' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_log`;
CREATE TABLE `oc_user_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `last_os` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '应用类型 1：android 2：ios',
  `online_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '在线时长',
  `last_online_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后在线时间',
  `last_offline_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后离线时间',
  `last_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后的IP地址',
  `cur_date` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '日期',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登录时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户活动记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_outflow
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_outflow`;
CREATE TABLE `oc_user_outflow`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `sex` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0保密 1男 2女',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码扰乱码',
  `album_count` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相册数量',
  `online` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0离线 1在线',
  `last_online` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后上线时间',
  `vip` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否会员 0不是会员 1是会员',
  `vip_expire_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员过期时间',
  `list_hide` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户主动设置隐藏 0不隐藏 1隐藏',
  `real` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '真人验证 默认0未验证 1通过真人验证',
  `is_consumers` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否付费用户 默认0:不是 1:是',
  `goddess` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '女神验证 默认0未验证 1通过女神验证',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '-1注册未完成 0注册完成 1冻结',
  `is_shield` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否屏蔽 0否 1是',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '流失的用户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_relation`;
CREATE TABLE `oc_user_relation`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `target_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联用户ID',
  `expire_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '过期时间',
  `type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1相册付费 2发送图片 3解锁聊天',
  `channel` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '绑定通道 0付费 1VIP 2真人 3女神',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户权限解锁' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_set
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_set`;
CREATE TABLE `oc_user_set`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `my_detail` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '个人详情 0公开 1相册付费 2查看需要验证',
  `open_money` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '付费查询费用',
  `list_hide` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '列表隐藏 0不隐藏 1隐藏',
  `distance_hide` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '距离隐藏 0 不隐藏 1隐藏',
  `online_time_hide` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '在线时间隐藏 0不隐藏 1隐藏',
  `account_hide` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '社交账号隐藏 0不隐藏 1隐藏',
  `allow_lianmai` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '允许连麦 0允许 1不允许',
  `private_chat_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '私聊消息通知 1接收 0不接收',
  `radio_enroll_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '广播报名通知 1接收 0不接收',
  `give_like_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '新点赞 1接收 0不接收',
  `comment_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论通知 1接收 0不接收',
  `new_redio_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '新广播提醒 1接收 0不接收',
  `view_request_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户通过了查看请求 1接收 0不接收',
  `invite_code_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '邀请码申请成功 1接收 0不接收',
  `sound_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '声音提醒 1接收 0不接收',
  `shock_notify` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '震动 1接收 0不接收',
  `update_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '隐私设置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_view
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_view`;
CREATE TABLE `oc_user_view`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `target_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被查看用户ID',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户查看用户详情记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_view_account_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_view_account_log`;
CREATE TABLE `oc_user_view_account_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `target_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被查看用户ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_view_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_view_log`;
CREATE TABLE `oc_user_view_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `target_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被查看用户ID',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1351 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户查看用户详情记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_user_wallet
-- ----------------------------
DROP TABLE IF EXISTS `oc_user_wallet`;
CREATE TABLE `oc_user_wallet`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `money` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '余额',
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币',
  `pay_pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付密码',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `pay_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收款账号',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '钱包表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_vip_package
-- ----------------------------
DROP TABLE IF EXISTS `oc_vip_package`;
CREATE TABLE `oc_vip_package`  (
  `vip_package_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '套餐标题',
  `discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠',
  `describe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '套餐价格',
  `day` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员天数',
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币',
  `weight` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '权重',
  `expire_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0永久 1按day计算',
  `recommend` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否是推荐 0不推荐 1推荐',
  `pay_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付编码',
  `device` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0安卓 1苹果',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '版本号',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0启用 1禁用',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`vip_package_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员套餐包' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_wallet_log
-- ----------------------------
DROP TABLE IF EXISTS `oc_wallet_log`;
CREATE TABLE `oc_wallet_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `target_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联用户ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `money` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '交易金额',
  `money_balance` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '交易前余额',
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币',
  `gold_balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币余额',
  `trans_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0支出 1收入',
  `business_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '交易类型 0红包',
  `currency_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '货币类型 1现金 2虚拟币',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '说明',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '钱包变动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `oc_withdraw`;
CREATE TABLE `oc_withdraw`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现用户',
  `wallet_log_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '钱包变动ID',
  `withdraw_type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现类型 0余额 1金币',
  `apply_money` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '用户请求提现金额',
  `apply_gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提现对应的币值',
  `withdraw_charge` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '手续费',
  `reality_money` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '实际到账金额',
  `payee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收款人',
  `pay_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '收款人账号',
  `gold_balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '颜值币余额',
  `money_balance` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '余额',
  `status` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0申请中 1审批通过 2交易完成 3审批不通过',
  `create_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '申请时间',
  `update_at` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提现表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for oc_zr_nymph
-- ----------------------------
DROP TABLE IF EXISTS `oc_zr_nymph`;
CREATE TABLE `oc_zr_nymph`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片路径',
  `old_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '旧图片路径（真人）',
  `face_discern` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '脸部识别（真人）',
  `match_score` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '匹配分数',
  `type` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片类型 1真人 2女神',
  `status` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认0 审核中 1审核通过 2审核不通过 3复审 4撤销',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_at` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '真人&amp;女神审核表' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;

﻿--[[
	Author: CYF
	Date: 2018年4月17日
	EMail: me@caoyongfeng.com
	Desc: Lesson Project
]]
local express = NPL.load('express');
local cors = NPL.load('cors');
local app = express:new();
local sitecfg = NPL.load('../confi/siteConfig');
local lang_cn = NPL.load('./confi/language/string_cn');
local lang_en = NPL.load('./confi/language/string_en');

app:set('views', 'views');
app:set('view engine', 'lustache');

app:use(cors(function(req, res)
	local url = req.url;
	return url:startsWith('/api/');
end, {
	is_current_origin = true
}));


app:use(function(req, res, next)
	-- 因为keepwork调用接口需要用到cookie，这样需要返回更具体的允许主机
	local host = req['Origin'];
	-- if string.find(host, 'keepwork.com') then
	if host then
		res:setHeader('Access-Control-Allow-Origin', host);
		res:setHeader('Access-Control-Allow-Credentials', 'true');
	end
	next(req, res, next);
end);

app:use(express.static('public'));
app:use(express.session());

app:use(function(req, res, next)
	local url = req.url;
	res.__data__ = {};
	res.__data__.baseUrl = sitecfg.lessonHost;
	res.__data__.keepworkHost = sitecfg.keepworkHost;
	if not (url:startsWith('/api/') or url:startsWith('/imgs/') or url:startsWith('/css/') or url:startsWith('/js/') or url:startsWith('/jslib/') or url:startsWith('/csslib/') or url:startsWith('/icons/')or url:startsWith('/uploads/') ) then
		-- 初始化
		res.__data__ = {};
		-- 获取 Accect Language，优先 Cookie 设置， 然后 Accect Language， 最后默认 en
		local resource = lang_en; -- 缺省值
		local langStr = 'EN'; -- 缺省值
		local lang  = req.cookies.language;
		local accectLang = req["Accept-Language"];
		-- accectLang = 'en-US'
		if(lang) then
			if(lang.value == 'en') then
				resource = lang_en;
				langStr = 'EN';
			elseif(lang.value == 'cn') then
				resource = lang_cn;
				langStr = 'CN';
			end
		elseif( accectLang ) then
			if( accectLang:startsWith('zh-CN') ) then
				resource = lang_cn;
				langStr = 'CN';
			elseif( accectLang:startsWith('en-US') ) then
				resource = lang_en;
				langStr = 'EN';
			end
		end
		if(req.query.__keepwork__) then
			res.__data__.headerShow = true
		end
		res.__data__.string = resource;
		res.__data__.language = langStr;
		res.__data__.frontResource = commonlib.Json.Encode(resource.front_resource);
	end
	next(req, res, next);
end);

-- ***********************************************************************
-- ****** API ******
-- ***********************************************************************
-- 课堂接口
local class = NPL.load('./api/class');
app:use('/api/class', class);

-- 用户接口
local member = NPL.load('./api/member');
app:use('/api/member', member);

-- 学习记录接口
local testrecord = NPL.load('./api/testrecord');
app:use('/api/record', testrecord);

-- 订单接口
local orders = NPL.load('./api/orders');
app:use('/api/order', orders);

-- 课程包接口
local package = NPL.load('./api/package');
app:use('/api/package', package);

-- 课程包订阅接口
local subscribe = NPL.load('./api/subscribe');
app:use('/api/subscribe', subscribe);

-- 激活码接口
local cdkey = NPL.load('./api/cdkey');
app:use('/api/cdkey', cdkey);

-- 后台管理员接口
local _mg_admin = NPL.load('./api/_mg_admin');
app:use('/api/_mg/admin', _mg_admin)

-- 首页
local router_index = NPL.load('./routes/index');
app:use('/', router_index);
app:use('/index', router_index);

-- 我的记录
local router_my_record = NPL.load('./routes/myRecord');
app:use('/myRecord', router_my_record);

-- 授课记录 & 自学记录
local router_record_list = NPL.load('./routes/recordList');
app:use('/recordList', router_record_list);

-- 自学记录 - 详情页
local router_record_learned = NPL.load('./routes/learnedRecord');
app:use('/learnedRecord', router_record_learned);

-- 授课记录 - 详情页
local router_record_taughted = NPL.load('./routes/taughtedRecord');
app:use('/taughtedRecord', router_record_taughted);

-- 购买
local router_buy = NPL.load('./routes/buy');
app:use('/buy', router_buy);

-- 课程中心
local router_lesson = NPL.load('./routes/lesson');
app:use('/lesson', router_lesson);

-- 学习记录
local router_learning_record = NPL.load('./routes/learningRecord');
app:use('/learningRecord', router_learning_record);

-- 教师专栏
local router_teacher_column = NPL.load('./routes/teacherColumn');
app:use('/teacherColumn', router_teacher_column);


-- ------ 后台管理首页 ---------------------------------------------------
local mg_index = NPL.load('./routes/_mg');
app:use('/_mg', mg_index);

-- ***********************************************************************
-- ****** 无法匹配URL的页面 ******
-- ***********************************************************************
app:use(function(req, res, next)
	res:setStatus(404);
	res:send({err = 404});
end);



NPL.export(app);
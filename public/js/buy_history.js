var username=$("#username").val();$(function(){getOrderHistory()});var getOrderHistory=function(e,i){$.get(LESSON_API+"/api/order/list",{psize:e,pno:i,username:username},function(e){var i=e.data;e.page;if(0==e.err)for(var r=$(".history-list"),a=0;a<i.length;a++){var s=i[a];0<=s.vipDay?s.expired="":s.expired="expired",0==s.goodsType?s.purchasingType="***/6":1==s.goodsType&&(s.purchasingType="***/12"),s.endTime=fmtDate(s.endTime,"dd, MM, yyyy"),s.orderTime=fmtDate(s.orderTime,"dd, MM, yyyy"),r.append('<ul class="history-item '+s.expired+'">    <li class="el-row--flex">        <span>Purchasing Type:</span>        <div>USD '+s.purchasingType+' months</div>    </li>\t    <li class="el-row--flex">        <span>Valid Until:</span>        <div>'+s.endTime+'</div>    </li>    <li class="el-row--flex">        <span>Purchasing Date:</span>        <div>'+s.orderTime+"</div>    </li></ul>")}})};
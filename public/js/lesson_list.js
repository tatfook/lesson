$(function(){$.ajax({type:"GET",url:LESSON_API+"/api/class/pkgs",complete:function(a){var s=JSON.parse(a.responseText);$(".lesson-total").text(s.hits.total);var e=s.hits.hits;if(e)for(var l=0;l<e.length;l++){var t=e[l]._source;n(t),0==t.agesMax&&0==t.agesMin?t.ageMsg=R.suitable4all:t.ageMsg=t.agesMin+"-"+t.agesMax;var o='<div class="el-col el-col-12 el-col-xs-12 el-col-sm-12 el-col-md-8 el-col-lg-8 el-col-xl-8"><div class="item">    <a href="'+t.url+'" target="_blank" class="lesson-cover">        <div style="background-image: url('+t.cover+');"></div>    </a>    <a href="'+t.url+'" target="_blank" class="title">'+t.title+'</a>    <div class="time">'+R.include+": <span>"+t.lessonCount+"</span> "+R.lessons+'</div>    <div class="ages">'+R.ages+": <span>"+t.ageMsg+'</span></div>    <div class="skills">'+R.skills+": <span>"+t.skills+"</span></div> </div> ";$(".el-row").append(o)}}}),mdToJson=function(a){var s;try{s=jsyaml.safeLoad(a)}catch(a){console.error(a)}return s||{}};var n=function(a){for(var s,e=a.content.split("```"),l=0;l<e.length;l++){var t=e[l];if(t.startWith("@LessonPackage")){t=t.replace("@LessonPackage",""),s=mdToJson(t.trim());break}}s&&(a.title=s.lessonPackage.data.title,a.url=KEEPWORK_HOST+a.url,a.cover=s.lessonPackage.data.cover,a.skills=s.lessonPackage.data.skills,a.agesMin=s.lessonPackage.data.agesMin,a.agesMax=s.lessonPackage.data.agesMax,a.cost=s.lessonPackage.data.cost,a.lessonCount=s.lessonPackage.data.lessonCount)}});
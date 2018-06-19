local db = NPL.load("../dal/dbutil")

local testrecord = {}

local tbl = "testrecord"

testrecord.get = function(where, group, order, cn)
    local sql =
        [[SELECT sn, beginTime, totalScore, rightCount, wrongCount, emptyCount, answerSheet, finishTime, lessonNo, lessonTitle, lessonUrl, username, codeReadLine, codeWriteLine, commands FROM testrecord]]
    return db.detail(sql, where, group, order, cn)
end

testrecord.save = function(testrecord, cn)
    return db.insert(tbl, testrecord, cn)
end

testrecord.update = function(testrecord, cn)
    return db.updateBySn(tbl, testrecord, cn)
end

testrecord.updateDuration = function(sn, cn)
    local sql = "update testrecord set duration = duration + 1 where sn = ?sn"
    return db.execute(sql, {sn = sn}, cn)
end

testrecord.learnRecord = function(where, group, order, limit, cn)
    local sql =
        [[SELECT lessonUrl, lessonTitle, lessonCover, goals, lessonNo, MAX(totalScore) bestScore,
        (SELECT totalScore FROM testrecord WHERE lessonNo = t.lessonNo AND username = t.username ORDER BY finishTime DESC LIMIT 0,1) latestScore
        FROM testrecord t]]
    return db.findJoin(sql, where, group, order, limit, cn)
end

testrecord.detail = function(where, group, order, limit, cn)
    local sql =
        [[SELECT sn, beginTime, totalScore, rightCount, wrongCount, emptyCount, answerSheet, finishTime, lessonNo, lessonTitle, lessonUrl, username, codeReadLine, codeWriteLine, commands FROM testrecord]]
    return db.findJoin(sql, where, group, order, limit, cn)
end

testrecord.detailBySn = function(where, group, order, cn)
    local sql =
        [[SELECT beginTime, t.username, totalScore, rightCount, wrongCount, emptyCount, answerSheet, finishTime, lessonNo, lessonPerformance, duration, lessonTitle, state, DATEDIFF(t.`beginTime`,m.`joinTime`) learnedDays FROM testrecord t LEFT JOIN member m ON t.`username` = m.`username`]]
    return db.detail(sql, where, group, order, cn)
end

testrecord.detailByLessonUrl = function(where, group, order, cn)
    local sql =
        [[SELECT t.`lessonTitle`, t.`beginTime`, t.`lessonCover`, t.`goals`, t.`lessonNo`, t.username, m.`codeReadLine`, m.`codeWriteLine`, m.`commands`, m.`displayName`, m.`presenter`,  DATEDIFF(t.`beginTime`,m.`joinTime`) learnedDays
        FROM testrecord t LEFT JOIN member m ON t.`username` = m.`username`]]
    return db.detail(sql, where, group, order, cn)
end

testrecord.updateBath = function(set, inCase, cn)
    return db.updateStatusBatch(tbl, set, inCase, cn)
end

NPL.export(testrecord)

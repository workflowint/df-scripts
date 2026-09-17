IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'File Search')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('File Search', 'FS', 1, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Benchmark')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Benchmark', 'BM', 2, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Target Companies')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Target Companies', 'TC', 3, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Ad Respondents')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Ad Respondents', 'AR', 4, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Internal Search')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Internal Search', 'IS', 5, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Sources')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Sources', 'SO', 6, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Referrals')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Referrals', 'SR', 7, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Contact Register')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Contact Register', 'CR', 8, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Internal Interview')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Internal Interview', 'II', 9, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Presented')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Presented', 'PR', 10, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Client Interview')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Client Interview', 'CI', 11, 1)
GO
IF NOT EXISTS( SELECT ListNum FROM WorkLists WITH(NOLOCK) WHERE ListName LIKE 'Placed')
INSERT INTO WorkLists
(ListName, ListAbbrev, ListNum, ListInUse)
VALUES
('Placed', 'PL', 12, 1)
GO
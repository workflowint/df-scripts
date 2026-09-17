ALTER TABLE ResumeJinniConfig add WebTemplateID int, WebSubject varchar(255) ,WebFormat int
GO
ALTER TABLE Projects add WebTemplateID int, WebSubject varchar(255) ,WebFormat int
GO
ALTER TABLE WebSites add SiteWebTemplateID int, SiteWebSubject varchar(255), SiteWebFormat int
GO
ALTER TABLE LinkWebPostingToWebSite add PostingSiteWebTemplateID int, PostingSiteWebSubject varchar(255), PostingSiteWebFormat int
GO
ALTER TABLE Duplicates  add FromWebSiteID int
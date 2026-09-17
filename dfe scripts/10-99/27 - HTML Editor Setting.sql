ALTER Table ClientConfig
ADD WebEditorAPI varchar(255) NULL,
    WebEditorAPIKey varchar(255) NULL
GO

UPDATE ClientConfig
SET WebEditorAPI = 'https://deskflow-asp2.com/dfe-html/',
    WebEditorAPIKey = 'WJ6uZGDbYG'
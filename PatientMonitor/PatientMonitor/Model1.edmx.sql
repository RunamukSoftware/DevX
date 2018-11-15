
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 11/22/2015 17:27:57
-- Generated from EDMX file: c:\users\runamuk0\documents\visual studio 2015\Projects\ConsoleApplication2\ConsoleApplication2\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [MedicalInfo];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Patients'
CREATE TABLE [dbo].[Patients] (
    [PatientID] int IDENTITY(1,1) NOT NULL,
    [FirstName] nvarchar(255)  NOT NULL,
    [LastName] nvarchar(255)  NOT NULL,
    [Address1] nvarchar(255)  NOT NULL,
    [Address2] nvarchar(255)  NOT NULL,
    [City] nvarchar(100)  NOT NULL,
    [State] nvarchar(50)  NOT NULL,
    [ZipCode] nvarchar(10)  NOT NULL,
    [MedicalRecordNumber] nvarchar(50)  NOT NULL
);
GO

-- Creating table 'Monitors'
CREATE TABLE [dbo].[Monitors] (
    [MonitorID] int IDENTITY(1,1) NOT NULL,
    [Type] nvarchar(50)  NOT NULL,
    [ModelNumber] nvarchar(50)  NOT NULL,
    [PatientID] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [PatientID] in table 'Patients'
ALTER TABLE [dbo].[Patients]
ADD CONSTRAINT [PK_Patients]
    PRIMARY KEY CLUSTERED ([PatientID] ASC);
GO

-- Creating primary key on [MonitorID] in table 'Monitors'
ALTER TABLE [dbo].[Monitors]
ADD CONSTRAINT [PK_Monitors]
    PRIMARY KEY CLUSTERED ([MonitorID] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [PatientID] in table 'Monitors'
ALTER TABLE [dbo].[Monitors]
ADD CONSTRAINT [FK_PatientMonitor]
    FOREIGN KEY ([PatientID])
    REFERENCES [dbo].[Patients]
        ([PatientID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PatientMonitor'
CREATE INDEX [IX_FK_PatientMonitor]
ON [dbo].[Monitors]
    ([PatientID]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------
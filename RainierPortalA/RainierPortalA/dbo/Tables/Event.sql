CREATE TABLE [dbo].[Event] (
    [EventID]         INT           NOT NULL,
    [Timestamp]       ROWVERSION    NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Event_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Event_EventID] PRIMARY KEY CLUSTERED ([EventID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'All events are formally defined.  They don''t leave it up to individual clients to infer an event from various property changes.  Examples of events

    Admit, Discharge,Transfer , P2DAssociate, P2DDisassocate

Events are what is stored for retrospective data - think an event log as  stream of events.    Devices, Patients, and Org''s will have event logs.

OPEN issue:  How to get the current state of object (eg Alarm) from a event log.  
1) either capture entire state of object with every event (storage/net bloat?) or 
2) Send periodic checkpoints  then the current state can be reconstructed by apply deltas to last checkpoint.   
Option 1 may constrain the logical design of an object (implementation details on property size''s) ,  Option 2 is extra coding someplace.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Event';


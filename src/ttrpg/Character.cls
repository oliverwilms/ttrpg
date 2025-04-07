Class TTRPG.Character Extends %Persistent
{

Property Name As %String [ Required ];

Property Race As %String;

Property Class As %String;

Property Level As %String;

Index IndexName On Name [ IdKey ];

ClassMethod GetCharByName(name As %String) As TTRPG.Character
{
    set character = ##class(TTRPG.Character).%OpenId(name)

    Quit character
}

ClassMethod GetCharacterByName(charName As %String) As %DynamicObject
{
   // Create a new dynamic object to store the results
        Set results = {}

        set char = ##class(TTRPG.Character).GetCharByName(charName)

        if char {
           set charInfo = {}
            set charInfo.Name = char.Name
            set charInfo.Class = char.Class
            set charInfo.Race = char.Race
            set charInfo.Level = char.Level
            set results.Character = charInfo
            Set results.Status = "success"
        }
        // If no character was found, set an error message in the results object
        else {
            Set results.Status = "error"
            Set results.Message = "No characters found"
        }

        // Return the results object
        Quit results
}

ClassMethod GetCharacterList() As %DynamicObject
{
    // Create a new dynamic object to store the results
        Set results = {}
        set query = "SELECT Name, Class, Race, ""Level"" FROM TTRPG.""Character"""
        set tStatement = ##class(%SQL.Statement).%New()
        set qstatus = tStatement.%Prepare(query)
        if qstatus '= 1 { Do ##class(TTRPG.impl).%WriteResponse("Error: " _ $SYSTEM.Status.DisplayError(qstatus)) }
        set rset = tStatement.%Execute()
        Set characterList = []
        while rset.%Next(){
            Set characterInfo = {}
            Set characterInfo.Name = rset.Name
            set characterInfo.Race = rset.Race
            Set characterInfo.Class = rset.Class
            Set characterInfo.Level = rset.Level 

            Do characterList.%Push(characterInfo)

        }
        if (rset.%SQLCODE < 0) {write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}

        set totalCount = rset.%ROWCOUNT

            // Set the status, totalCount, and characterList properties in the results object
            Set results.Status = "success"
            Set results.TotalCount = totalCount
            Set results.CharacterList = characterList


        // Return the results object
        Quit results
}

ClassMethod PostCharacter(name As %String, class As %String, race As %String, level As %String) As %DynamicObject
{
    set results = {} // create the return %DynamicObject

    //create the character object
    set char = ##class(TTRPG.Character).%New()

    set char.Name = name
    set char.Class = class
    set char.Race = race
    set char.Level = level
    set st = char.%Save()

    if st {
        set charInfo = {}
        set charInfo.Name = char.Name
        set charInfo.Class = char.Class
        set charInfo.Race = char.Race
        set charInfo.Level = char.Level
        set results.Character = charInfo
        Set results.Status = "success"
    }
    else {
        Set results.Status = "error"
        Set results.Message = "Unable to create the character"
    }
    Quit results
}

}

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

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
}

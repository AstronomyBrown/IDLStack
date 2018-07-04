/**
 * Type.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Type implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected Type(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _Other = "Other";
    public static final java.lang.String _Archive = "Archive";
    public static final java.lang.String _Bibliography = "Bibliography";
    public static final java.lang.String _Catalog = "Catalog";
    public static final java.lang.String _Journal = "Journal";
    public static final java.lang.String _Library = "Library";
    public static final java.lang.String _Simulation = "Simulation";
    public static final java.lang.String _Survey = "Survey";
    public static final java.lang.String _Transformation = "Transformation";
    public static final java.lang.String _Education = "Education";
    public static final java.lang.String _Outreach = "Outreach";
    public static final java.lang.String _EPOResource = "EPOResource";
    public static final java.lang.String _Animation = "Animation";
    public static final java.lang.String _Artwork = "Artwork";
    public static final java.lang.String _Background = "Background";
    public static final java.lang.String _BasicData = "BasicData";
    public static final java.lang.String _Historical = "Historical";
    public static final java.lang.String _Photographic = "Photographic";
    public static final java.lang.String _Press = "Press";
    public static final java.lang.String _Organisation = "Organisation";
    public static final java.lang.String _Project = "Project";
    public static final java.lang.String _Registry = "Registry";
    public static final Type Other = new Type(_Other);
    public static final Type Archive = new Type(_Archive);
    public static final Type Bibliography = new Type(_Bibliography);
    public static final Type Catalog = new Type(_Catalog);
    public static final Type Journal = new Type(_Journal);
    public static final Type Library = new Type(_Library);
    public static final Type Simulation = new Type(_Simulation);
    public static final Type Survey = new Type(_Survey);
    public static final Type Transformation = new Type(_Transformation);
    public static final Type Education = new Type(_Education);
    public static final Type Outreach = new Type(_Outreach);
    public static final Type EPOResource = new Type(_EPOResource);
    public static final Type Animation = new Type(_Animation);
    public static final Type Artwork = new Type(_Artwork);
    public static final Type Background = new Type(_Background);
    public static final Type BasicData = new Type(_BasicData);
    public static final Type Historical = new Type(_Historical);
    public static final Type Photographic = new Type(_Photographic);
    public static final Type Press = new Type(_Press);
    public static final Type Organisation = new Type(_Organisation);
    public static final Type Project = new Type(_Project);
    public static final Type Registry = new Type(_Registry);
    public java.lang.String getValue() { return _value_;}
    public static Type fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        Type enumeration = (Type)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static Type fromString(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        return fromValue(value);
    }
    public boolean equals(java.lang.Object obj) {return (obj == this);}
    public int hashCode() { return toString().hashCode();}
    public java.lang.String toString() { return _value_;}
    public java.lang.Object readResolve() throws java.io.ObjectStreamException { return fromValue(_value_);}
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumSerializer(
            _javaType, _xmlType);
    }
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumDeserializer(
            _javaType, _xmlType);
    }
    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Type.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Type"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}

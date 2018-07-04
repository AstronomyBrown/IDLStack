/**
 * Capability.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Capability  implements java.io.Serializable {
    private org.apache.axis.types.URI standardID;  // attribute
    private org.apache.axis.types.URI standardURL;  // attribute

    public Capability() {
    }


    /**
     * Gets the standardID value for this Capability.
     * 
     * @return standardID
     */
    public org.apache.axis.types.URI getStandardID() {
        return standardID;
    }


    /**
     * Sets the standardID value for this Capability.
     * 
     * @param standardID
     */
    public void setStandardID(org.apache.axis.types.URI standardID) {
        this.standardID = standardID;
    }


    /**
     * Gets the standardURL value for this Capability.
     * 
     * @return standardURL
     */
    public org.apache.axis.types.URI getStandardURL() {
        return standardURL;
    }


    /**
     * Sets the standardURL value for this Capability.
     * 
     * @param standardURL
     */
    public void setStandardURL(org.apache.axis.types.URI standardURL) {
        this.standardURL = standardURL;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Capability)) return false;
        Capability other = (Capability) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.standardID==null && other.getStandardID()==null) || 
             (this.standardID!=null &&
              this.standardID.equals(other.getStandardID()))) &&
            ((this.standardURL==null && other.getStandardURL()==null) || 
             (this.standardURL!=null &&
              this.standardURL.equals(other.getStandardURL())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getStandardID() != null) {
            _hashCode += getStandardID().hashCode();
        }
        if (getStandardURL() != null) {
            _hashCode += getStandardURL().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Capability.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Capability"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("standardID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "standardID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("standardURL");
        attrField.setXmlName(new javax.xml.namespace.QName("", "standardURL"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        typeDesc.addFieldDesc(attrField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}

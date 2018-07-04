/**
 * AccessURL.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class AccessURL  implements java.io.Serializable, org.apache.axis.encoding.SimpleType {
    private org.apache.axis.types.URI value;
    private net.ivoa.www.xml.VOResource.v0_10.AccessURLUse use;  // attribute

    public AccessURL() {
    }

    // Simple Types must have a String constructor
    public AccessURL(org.apache.axis.types.URI value) {
        this.value = value;
    }
    public AccessURL(java.lang.String value) {
        try {
            this.value = new org.apache.axis.types.URI(value);
        }
        catch (org.apache.axis.types.URI.MalformedURIException mue) {
            throw new java.lang.RuntimeException(mue.toString());
       }
    }

    // Simple Types must have a toString for serializing the value
    public java.lang.String toString() {
        return value == null ? null : value.toString();
    }


    /**
     * Gets the value value for this AccessURL.
     * 
     * @return value
     */
    public org.apache.axis.types.URI getValue() {
        return value;
    }


    /**
     * Sets the value value for this AccessURL.
     * 
     * @param value
     */
    public void setValue(org.apache.axis.types.URI value) {
        this.value = value;
    }


    /**
     * Gets the use value for this AccessURL.
     * 
     * @return use
     */
    public net.ivoa.www.xml.VOResource.v0_10.AccessURLUse getUse() {
        return use;
    }


    /**
     * Sets the use value for this AccessURL.
     * 
     * @param use
     */
    public void setUse(net.ivoa.www.xml.VOResource.v0_10.AccessURLUse use) {
        this.use = use;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AccessURL)) return false;
        AccessURL other = (AccessURL) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.value==null && other.getValue()==null) || 
             (this.value!=null &&
              this.value.equals(other.getValue()))) &&
            ((this.use==null && other.getUse()==null) || 
             (this.use!=null &&
              this.use.equals(other.getUse())));
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
        if (getValue() != null) {
            _hashCode += getValue().hashCode();
        }
        if (getUse() != null) {
            _hashCode += getUse().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AccessURL.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "AccessURL"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("use");
        attrField.setXmlName(new javax.xml.namespace.QName("", "use"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "AccessURLUse"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("", "value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        typeDesc.addFieldDesc(elemField);
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
          new  org.apache.axis.encoding.ser.SimpleSerializer(
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
          new  org.apache.axis.encoding.ser.SimpleDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}

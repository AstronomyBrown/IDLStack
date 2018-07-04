/**
 * STREAM.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class STREAM  implements java.io.Serializable, org.apache.axis.encoding.SimpleType {
    private java.lang.String value;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMType type;  // attribute
    private org.apache.axis.types.URI href;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMActuate actuate;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.EncodingType encoding;  // attribute
    private java.util.Calendar expires;  // attribute
    private org.apache.axis.types.Token rights;  // attribute

    public STREAM() {
    }

    // Simple Types must have a String constructor
    public STREAM(java.lang.String value) {
        this.value = value;
    }
    // Simple Types must have a toString for serializing the value
    public java.lang.String toString() {
        return value;
    }


    /**
     * Gets the value value for this STREAM.
     * 
     * @return value
     */
    public java.lang.String getValue() {
        return value;
    }


    /**
     * Sets the value value for this STREAM.
     * 
     * @param value
     */
    public void setValue(java.lang.String value) {
        this.value = value;
    }


    /**
     * Gets the type value for this STREAM.
     * 
     * @return type
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMType getType() {
        return type;
    }


    /**
     * Sets the type value for this STREAM.
     * 
     * @param type
     */
    public void setType(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMType type) {
        this.type = type;
    }


    /**
     * Gets the href value for this STREAM.
     * 
     * @return href
     */
    public org.apache.axis.types.URI getHref() {
        return href;
    }


    /**
     * Sets the href value for this STREAM.
     * 
     * @param href
     */
    public void setHref(org.apache.axis.types.URI href) {
        this.href = href;
    }


    /**
     * Gets the actuate value for this STREAM.
     * 
     * @return actuate
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMActuate getActuate() {
        return actuate;
    }


    /**
     * Sets the actuate value for this STREAM.
     * 
     * @param actuate
     */
    public void setActuate(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMActuate actuate) {
        this.actuate = actuate;
    }


    /**
     * Gets the encoding value for this STREAM.
     * 
     * @return encoding
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.EncodingType getEncoding() {
        return encoding;
    }


    /**
     * Sets the encoding value for this STREAM.
     * 
     * @param encoding
     */
    public void setEncoding(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.EncodingType encoding) {
        this.encoding = encoding;
    }


    /**
     * Gets the expires value for this STREAM.
     * 
     * @return expires
     */
    public java.util.Calendar getExpires() {
        return expires;
    }


    /**
     * Sets the expires value for this STREAM.
     * 
     * @param expires
     */
    public void setExpires(java.util.Calendar expires) {
        this.expires = expires;
    }


    /**
     * Gets the rights value for this STREAM.
     * 
     * @return rights
     */
    public org.apache.axis.types.Token getRights() {
        return rights;
    }


    /**
     * Sets the rights value for this STREAM.
     * 
     * @param rights
     */
    public void setRights(org.apache.axis.types.Token rights) {
        this.rights = rights;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof STREAM)) return false;
        STREAM other = (STREAM) obj;
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
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType()))) &&
            ((this.href==null && other.getHref()==null) || 
             (this.href!=null &&
              this.href.equals(other.getHref()))) &&
            ((this.actuate==null && other.getActuate()==null) || 
             (this.actuate!=null &&
              this.actuate.equals(other.getActuate()))) &&
            ((this.encoding==null && other.getEncoding()==null) || 
             (this.encoding!=null &&
              this.encoding.equals(other.getEncoding()))) &&
            ((this.expires==null && other.getExpires()==null) || 
             (this.expires!=null &&
              this.expires.equals(other.getExpires()))) &&
            ((this.rights==null && other.getRights()==null) || 
             (this.rights!=null &&
              this.rights.equals(other.getRights())));
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
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        if (getHref() != null) {
            _hashCode += getHref().hashCode();
        }
        if (getActuate() != null) {
            _hashCode += getActuate().hashCode();
        }
        if (getEncoding() != null) {
            _hashCode += getEncoding().hashCode();
        }
        if (getExpires() != null) {
            _hashCode += getExpires().hashCode();
        }
        if (getRights() != null) {
            _hashCode += getRights().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(STREAM.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAM"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("type");
        attrField.setXmlName(new javax.xml.namespace.QName("", "type"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAMType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("href");
        attrField.setXmlName(new javax.xml.namespace.QName("", "href"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("actuate");
        attrField.setXmlName(new javax.xml.namespace.QName("", "actuate"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAMActuate"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("encoding");
        attrField.setXmlName(new javax.xml.namespace.QName("", "encoding"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "encodingType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("expires");
        attrField.setXmlName(new javax.xml.namespace.QName("", "expires"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("rights");
        attrField.setXmlName(new javax.xml.namespace.QName("", "rights"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("", "value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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

/**
 * FITS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class FITS  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAM STREAM;
    private org.apache.axis.types.PositiveInteger extnum;  // attribute

    public FITS() {
    }


    /**
     * Gets the STREAM value for this FITS.
     * 
     * @return STREAM
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAM getSTREAM() {
        return STREAM;
    }


    /**
     * Sets the STREAM value for this FITS.
     * 
     * @param STREAM
     */
    public void setSTREAM(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAM STREAM) {
        this.STREAM = STREAM;
    }


    /**
     * Gets the extnum value for this FITS.
     * 
     * @return extnum
     */
    public org.apache.axis.types.PositiveInteger getExtnum() {
        return extnum;
    }


    /**
     * Sets the extnum value for this FITS.
     * 
     * @param extnum
     */
    public void setExtnum(org.apache.axis.types.PositiveInteger extnum) {
        this.extnum = extnum;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FITS)) return false;
        FITS other = (FITS) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.STREAM==null && other.getSTREAM()==null) || 
             (this.STREAM!=null &&
              this.STREAM.equals(other.getSTREAM()))) &&
            ((this.extnum==null && other.getExtnum()==null) || 
             (this.extnum!=null &&
              this.extnum.equals(other.getExtnum())));
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
        if (getSTREAM() != null) {
            _hashCode += getSTREAM().hashCode();
        }
        if (getExtnum() != null) {
            _hashCode += getExtnum().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FITS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FITS"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("extnum");
        attrField.setXmlName(new javax.xml.namespace.QName("", "extnum"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "positiveInteger"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STREAM");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAM"));
        elemField.setMinOccurs(0);
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

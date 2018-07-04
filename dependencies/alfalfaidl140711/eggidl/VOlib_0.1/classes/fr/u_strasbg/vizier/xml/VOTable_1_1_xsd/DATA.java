/**
 * DATA.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class DATA  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLEDATA TABLEDATA;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FITS FITS;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.BINARY BINARY;

    public DATA() {
    }


    /**
     * Gets the TABLEDATA value for this DATA.
     * 
     * @return TABLEDATA
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLEDATA getTABLEDATA() {
        return TABLEDATA;
    }


    /**
     * Sets the TABLEDATA value for this DATA.
     * 
     * @param TABLEDATA
     */
    public void setTABLEDATA(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLEDATA TABLEDATA) {
        this.TABLEDATA = TABLEDATA;
    }


    /**
     * Gets the FITS value for this DATA.
     * 
     * @return FITS
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FITS getFITS() {
        return FITS;
    }


    /**
     * Sets the FITS value for this DATA.
     * 
     * @param FITS
     */
    public void setFITS(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FITS FITS) {
        this.FITS = FITS;
    }


    /**
     * Gets the BINARY value for this DATA.
     * 
     * @return BINARY
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.BINARY getBINARY() {
        return BINARY;
    }


    /**
     * Sets the BINARY value for this DATA.
     * 
     * @param BINARY
     */
    public void setBINARY(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.BINARY BINARY) {
        this.BINARY = BINARY;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DATA)) return false;
        DATA other = (DATA) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.TABLEDATA==null && other.getTABLEDATA()==null) || 
             (this.TABLEDATA!=null &&
              this.TABLEDATA.equals(other.getTABLEDATA()))) &&
            ((this.FITS==null && other.getFITS()==null) || 
             (this.FITS!=null &&
              this.FITS.equals(other.getFITS()))) &&
            ((this.BINARY==null && other.getBINARY()==null) || 
             (this.BINARY!=null &&
              this.BINARY.equals(other.getBINARY())));
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
        if (getTABLEDATA() != null) {
            _hashCode += getTABLEDATA().hashCode();
        }
        if (getFITS() != null) {
            _hashCode += getFITS().hashCode();
        }
        if (getBINARY() != null) {
            _hashCode += getBINARY().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DATA.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DATA"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TABLEDATA");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLEDATA"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLEDATA"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("FITS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FITS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FITS"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BINARY");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "BINARY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "BINARY"));
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

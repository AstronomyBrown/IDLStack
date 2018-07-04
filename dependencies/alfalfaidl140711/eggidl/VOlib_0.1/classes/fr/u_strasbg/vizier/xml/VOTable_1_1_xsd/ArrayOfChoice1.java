/**
 * ArrayOfChoice1.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class ArrayOfChoice1  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM PARAM;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS COOSYS;

    public ArrayOfChoice1() {
    }


    /**
     * Gets the PARAM value for this ArrayOfChoice1.
     * 
     * @return PARAM
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM getPARAM() {
        return PARAM;
    }


    /**
     * Sets the PARAM value for this ArrayOfChoice1.
     * 
     * @param PARAM
     */
    public void setPARAM(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM PARAM) {
        this.PARAM = PARAM;
    }


    /**
     * Gets the COOSYS value for this ArrayOfChoice1.
     * 
     * @return COOSYS
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS getCOOSYS() {
        return COOSYS;
    }


    /**
     * Sets the COOSYS value for this ArrayOfChoice1.
     * 
     * @param COOSYS
     */
    public void setCOOSYS(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS COOSYS) {
        this.COOSYS = COOSYS;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfChoice1)) return false;
        ArrayOfChoice1 other = (ArrayOfChoice1) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.PARAM==null && other.getPARAM()==null) || 
             (this.PARAM!=null &&
              this.PARAM.equals(other.getPARAM()))) &&
            ((this.COOSYS==null && other.getCOOSYS()==null) || 
             (this.COOSYS!=null &&
              this.COOSYS.equals(other.getCOOSYS())));
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
        if (getPARAM() != null) {
            _hashCode += getPARAM().hashCode();
        }
        if (getCOOSYS() != null) {
            _hashCode += getCOOSYS().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArrayOfChoice1.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "ArrayOfChoice1"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PARAM");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAM"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COOSYS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS"));
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

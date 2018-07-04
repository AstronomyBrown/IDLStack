/**
 * COOSYS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class COOSYS  implements java.io.Serializable, org.apache.axis.encoding.MixedContentType {
    private org.apache.axis.message.MessageElement [] _any;  // attribute
    private org.apache.axis.types.Id ID;  // attribute
    private org.apache.axis.types.Token equinox;  // attribute
    private org.apache.axis.types.Token epoch;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYSSystem system;  // attribute

    public COOSYS() {
    }


    /**
     * Gets the _any value for this COOSYS.
     * 
     * @return _any
     */
    public org.apache.axis.message.MessageElement [] get_any() {
        return _any;
    }


    /**
     * Sets the _any value for this COOSYS.
     * 
     * @param _any
     */
    public void set_any(org.apache.axis.message.MessageElement [] _any) {
        this._any = _any;
    }


    /**
     * Gets the ID value for this COOSYS.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this COOSYS.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the equinox value for this COOSYS.
     * 
     * @return equinox
     */
    public org.apache.axis.types.Token getEquinox() {
        return equinox;
    }


    /**
     * Sets the equinox value for this COOSYS.
     * 
     * @param equinox
     */
    public void setEquinox(org.apache.axis.types.Token equinox) {
        this.equinox = equinox;
    }


    /**
     * Gets the epoch value for this COOSYS.
     * 
     * @return epoch
     */
    public org.apache.axis.types.Token getEpoch() {
        return epoch;
    }


    /**
     * Sets the epoch value for this COOSYS.
     * 
     * @param epoch
     */
    public void setEpoch(org.apache.axis.types.Token epoch) {
        this.epoch = epoch;
    }


    /**
     * Gets the system value for this COOSYS.
     * 
     * @return system
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYSSystem getSystem() {
        return system;
    }


    /**
     * Sets the system value for this COOSYS.
     * 
     * @param system
     */
    public void setSystem(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYSSystem system) {
        this.system = system;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof COOSYS)) return false;
        COOSYS other = (COOSYS) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this._any==null && other.get_any()==null) || 
             (this._any!=null &&
              java.util.Arrays.equals(this._any, other.get_any()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.equinox==null && other.getEquinox()==null) || 
             (this.equinox!=null &&
              this.equinox.equals(other.getEquinox()))) &&
            ((this.epoch==null && other.getEpoch()==null) || 
             (this.epoch!=null &&
              this.epoch.equals(other.getEpoch()))) &&
            ((this.system==null && other.getSystem()==null) || 
             (this.system!=null &&
              this.system.equals(other.getSystem())));
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
        if (get_any() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(get_any());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(get_any(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getEquinox() != null) {
            _hashCode += getEquinox().hashCode();
        }
        if (getEpoch() != null) {
            _hashCode += getEpoch().hashCode();
        }
        if (getSystem() != null) {
            _hashCode += getSystem().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(COOSYS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("equinox");
        attrField.setXmlName(new javax.xml.namespace.QName("", "equinox"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("epoch");
        attrField.setXmlName(new javax.xml.namespace.QName("", "epoch"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("system");
        attrField.setXmlName(new javax.xml.namespace.QName("", "system"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYSSystem"));
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

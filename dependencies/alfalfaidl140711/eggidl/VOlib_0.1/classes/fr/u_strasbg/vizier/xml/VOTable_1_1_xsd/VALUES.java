/**
 * VALUES.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class VALUES  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MIN MIN;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MAX MAX;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION[] OPTION;
    private org.apache.axis.types.Id ID;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUESType type;  // attribute
    private org.apache.axis.types.Token _null;  // attribute
    private org.apache.axis.types.IDRef ref;  // attribute

    public VALUES() {
    }


    /**
     * Gets the MIN value for this VALUES.
     * 
     * @return MIN
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MIN getMIN() {
        return MIN;
    }


    /**
     * Sets the MIN value for this VALUES.
     * 
     * @param MIN
     */
    public void setMIN(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MIN MIN) {
        this.MIN = MIN;
    }


    /**
     * Gets the MAX value for this VALUES.
     * 
     * @return MAX
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MAX getMAX() {
        return MAX;
    }


    /**
     * Sets the MAX value for this VALUES.
     * 
     * @param MAX
     */
    public void setMAX(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MAX MAX) {
        this.MAX = MAX;
    }


    /**
     * Gets the OPTION value for this VALUES.
     * 
     * @return OPTION
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION[] getOPTION() {
        return OPTION;
    }


    /**
     * Sets the OPTION value for this VALUES.
     * 
     * @param OPTION
     */
    public void setOPTION(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION[] OPTION) {
        this.OPTION = OPTION;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION getOPTION(int i) {
        return this.OPTION[i];
    }

    public void setOPTION(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION value) {
        this.OPTION[i] = value;
    }


    /**
     * Gets the ID value for this VALUES.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this VALUES.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the type value for this VALUES.
     * 
     * @return type
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUESType getType() {
        return type;
    }


    /**
     * Sets the type value for this VALUES.
     * 
     * @param type
     */
    public void setType(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUESType type) {
        this.type = type;
    }


    /**
     * Gets the _null value for this VALUES.
     * 
     * @return _null
     */
    public org.apache.axis.types.Token get_null() {
        return _null;
    }


    /**
     * Sets the _null value for this VALUES.
     * 
     * @param _null
     */
    public void set_null(org.apache.axis.types.Token _null) {
        this._null = _null;
    }


    /**
     * Gets the ref value for this VALUES.
     * 
     * @return ref
     */
    public org.apache.axis.types.IDRef getRef() {
        return ref;
    }


    /**
     * Sets the ref value for this VALUES.
     * 
     * @param ref
     */
    public void setRef(org.apache.axis.types.IDRef ref) {
        this.ref = ref;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof VALUES)) return false;
        VALUES other = (VALUES) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.MIN==null && other.getMIN()==null) || 
             (this.MIN!=null &&
              this.MIN.equals(other.getMIN()))) &&
            ((this.MAX==null && other.getMAX()==null) || 
             (this.MAX!=null &&
              this.MAX.equals(other.getMAX()))) &&
            ((this.OPTION==null && other.getOPTION()==null) || 
             (this.OPTION!=null &&
              java.util.Arrays.equals(this.OPTION, other.getOPTION()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType()))) &&
            ((this._null==null && other.get_null()==null) || 
             (this._null!=null &&
              this._null.equals(other.get_null()))) &&
            ((this.ref==null && other.getRef()==null) || 
             (this.ref!=null &&
              this.ref.equals(other.getRef())));
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
        if (getMIN() != null) {
            _hashCode += getMIN().hashCode();
        }
        if (getMAX() != null) {
            _hashCode += getMAX().hashCode();
        }
        if (getOPTION() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getOPTION());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getOPTION(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        if (get_null() != null) {
            _hashCode += get_null().hashCode();
        }
        if (getRef() != null) {
            _hashCode += getRef().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(VALUES.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUES"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("type");
        attrField.setXmlName(new javax.xml.namespace.QName("", "type"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUESType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("_null");
        attrField.setXmlName(new javax.xml.namespace.QName("", "null"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ref");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ref"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MIN");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MIN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MIN"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MAX");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MAX"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MAX"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("OPTION");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "OPTION"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "OPTION"));
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

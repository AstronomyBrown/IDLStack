/**
 * TABLE.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class TABLE  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM[] PARAM;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD[] FIELD;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP[] GROUP;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] LINK;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DATA DATA;
    private org.apache.axis.types.Id ID;  // attribute
    private org.apache.axis.types.Token name;  // attribute
    private org.apache.axis.types.IDRef ref;  // attribute

    public TABLE() {
    }


    /**
     * Gets the DESCRIPTION value for this TABLE.
     * 
     * @return DESCRIPTION
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT getDESCRIPTION() {
        return DESCRIPTION;
    }


    /**
     * Sets the DESCRIPTION value for this TABLE.
     * 
     * @param DESCRIPTION
     */
    public void setDESCRIPTION(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }


    /**
     * Gets the PARAM value for this TABLE.
     * 
     * @return PARAM
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM[] getPARAM() {
        return PARAM;
    }


    /**
     * Sets the PARAM value for this TABLE.
     * 
     * @param PARAM
     */
    public void setPARAM(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM[] PARAM) {
        this.PARAM = PARAM;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM getPARAM(int i) {
        return this.PARAM[i];
    }

    public void setPARAM(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM value) {
        this.PARAM[i] = value;
    }


    /**
     * Gets the FIELD value for this TABLE.
     * 
     * @return FIELD
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD[] getFIELD() {
        return FIELD;
    }


    /**
     * Sets the FIELD value for this TABLE.
     * 
     * @param FIELD
     */
    public void setFIELD(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD[] FIELD) {
        this.FIELD = FIELD;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD getFIELD(int i) {
        return this.FIELD[i];
    }

    public void setFIELD(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD value) {
        this.FIELD[i] = value;
    }


    /**
     * Gets the GROUP value for this TABLE.
     * 
     * @return GROUP
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP[] getGROUP() {
        return GROUP;
    }


    /**
     * Sets the GROUP value for this TABLE.
     * 
     * @param GROUP
     */
    public void setGROUP(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP[] GROUP) {
        this.GROUP = GROUP;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP getGROUP(int i) {
        return this.GROUP[i];
    }

    public void setGROUP(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP value) {
        this.GROUP[i] = value;
    }


    /**
     * Gets the LINK value for this TABLE.
     * 
     * @return LINK
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] getLINK() {
        return LINK;
    }


    /**
     * Sets the LINK value for this TABLE.
     * 
     * @param LINK
     */
    public void setLINK(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] LINK) {
        this.LINK = LINK;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK getLINK(int i) {
        return this.LINK[i];
    }

    public void setLINK(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK value) {
        this.LINK[i] = value;
    }


    /**
     * Gets the DATA value for this TABLE.
     * 
     * @return DATA
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DATA getDATA() {
        return DATA;
    }


    /**
     * Sets the DATA value for this TABLE.
     * 
     * @param DATA
     */
    public void setDATA(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DATA DATA) {
        this.DATA = DATA;
    }


    /**
     * Gets the ID value for this TABLE.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this TABLE.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the name value for this TABLE.
     * 
     * @return name
     */
    public org.apache.axis.types.Token getName() {
        return name;
    }


    /**
     * Sets the name value for this TABLE.
     * 
     * @param name
     */
    public void setName(org.apache.axis.types.Token name) {
        this.name = name;
    }


    /**
     * Gets the ref value for this TABLE.
     * 
     * @return ref
     */
    public org.apache.axis.types.IDRef getRef() {
        return ref;
    }


    /**
     * Sets the ref value for this TABLE.
     * 
     * @param ref
     */
    public void setRef(org.apache.axis.types.IDRef ref) {
        this.ref = ref;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TABLE)) return false;
        TABLE other = (TABLE) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.DESCRIPTION==null && other.getDESCRIPTION()==null) || 
             (this.DESCRIPTION!=null &&
              this.DESCRIPTION.equals(other.getDESCRIPTION()))) &&
            ((this.PARAM==null && other.getPARAM()==null) || 
             (this.PARAM!=null &&
              java.util.Arrays.equals(this.PARAM, other.getPARAM()))) &&
            ((this.FIELD==null && other.getFIELD()==null) || 
             (this.FIELD!=null &&
              java.util.Arrays.equals(this.FIELD, other.getFIELD()))) &&
            ((this.GROUP==null && other.getGROUP()==null) || 
             (this.GROUP!=null &&
              java.util.Arrays.equals(this.GROUP, other.getGROUP()))) &&
            ((this.LINK==null && other.getLINK()==null) || 
             (this.LINK!=null &&
              java.util.Arrays.equals(this.LINK, other.getLINK()))) &&
            ((this.DATA==null && other.getDATA()==null) || 
             (this.DATA!=null &&
              this.DATA.equals(other.getDATA()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
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
        if (getDESCRIPTION() != null) {
            _hashCode += getDESCRIPTION().hashCode();
        }
        if (getPARAM() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getPARAM());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getPARAM(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getFIELD() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getFIELD());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getFIELD(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getGROUP() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getGROUP());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getGROUP(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getLINK() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getLINK());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getLINK(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getDATA() != null) {
            _hashCode += getDATA().hashCode();
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getRef() != null) {
            _hashCode += getRef().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TABLE.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLE"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("name");
        attrField.setXmlName(new javax.xml.namespace.QName("", "name"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ref");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ref"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DESCRIPTION");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DESCRIPTION"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "anyTEXT"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PARAM");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAM"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("FIELD");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FIELD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FIELD"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("GROUP");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "GROUP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "GROUP"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LINK");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DATA");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DATA"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DATA"));
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

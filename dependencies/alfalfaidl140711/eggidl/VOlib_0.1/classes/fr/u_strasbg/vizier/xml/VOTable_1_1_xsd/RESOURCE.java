/**
 * RESOURCE.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class RESOURCE  implements java.io.Serializable, org.apache.axis.encoding.AnyContentType {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM PARAM;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.INFO INFO;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS COOSYS;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] LINK;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE[] TABLE;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE[] RESOURCE;
    private org.apache.axis.message.MessageElement [] _any;
    private org.apache.axis.types.Token name;  // attribute
    private org.apache.axis.types.Id ID;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCEType type;  // attribute

    public RESOURCE() {
    }


    /**
     * Gets the DESCRIPTION value for this RESOURCE.
     * 
     * @return DESCRIPTION
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT getDESCRIPTION() {
        return DESCRIPTION;
    }


    /**
     * Sets the DESCRIPTION value for this RESOURCE.
     * 
     * @param DESCRIPTION
     */
    public void setDESCRIPTION(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }


    /**
     * Gets the PARAM value for this RESOURCE.
     * 
     * @return PARAM
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM getPARAM() {
        return PARAM;
    }


    /**
     * Sets the PARAM value for this RESOURCE.
     * 
     * @param PARAM
     */
    public void setPARAM(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM PARAM) {
        this.PARAM = PARAM;
    }


    /**
     * Gets the INFO value for this RESOURCE.
     * 
     * @return INFO
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.INFO getINFO() {
        return INFO;
    }


    /**
     * Sets the INFO value for this RESOURCE.
     * 
     * @param INFO
     */
    public void setINFO(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.INFO INFO) {
        this.INFO = INFO;
    }


    /**
     * Gets the COOSYS value for this RESOURCE.
     * 
     * @return COOSYS
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS getCOOSYS() {
        return COOSYS;
    }


    /**
     * Sets the COOSYS value for this RESOURCE.
     * 
     * @param COOSYS
     */
    public void setCOOSYS(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS COOSYS) {
        this.COOSYS = COOSYS;
    }


    /**
     * Gets the LINK value for this RESOURCE.
     * 
     * @return LINK
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] getLINK() {
        return LINK;
    }


    /**
     * Sets the LINK value for this RESOURCE.
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
     * Gets the TABLE value for this RESOURCE.
     * 
     * @return TABLE
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE[] getTABLE() {
        return TABLE;
    }


    /**
     * Sets the TABLE value for this RESOURCE.
     * 
     * @param TABLE
     */
    public void setTABLE(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE[] TABLE) {
        this.TABLE = TABLE;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE getTABLE(int i) {
        return this.TABLE[i];
    }

    public void setTABLE(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE value) {
        this.TABLE[i] = value;
    }


    /**
     * Gets the RESOURCE value for this RESOURCE.
     * 
     * @return RESOURCE
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE[] getRESOURCE() {
        return RESOURCE;
    }


    /**
     * Sets the RESOURCE value for this RESOURCE.
     * 
     * @param RESOURCE
     */
    public void setRESOURCE(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE[] RESOURCE) {
        this.RESOURCE = RESOURCE;
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE getRESOURCE(int i) {
        return this.RESOURCE[i];
    }

    public void setRESOURCE(int i, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE value) {
        this.RESOURCE[i] = value;
    }


    /**
     * Gets the _any value for this RESOURCE.
     * 
     * @return _any
     */
    public org.apache.axis.message.MessageElement [] get_any() {
        return _any;
    }


    /**
     * Sets the _any value for this RESOURCE.
     * 
     * @param _any
     */
    public void set_any(org.apache.axis.message.MessageElement [] _any) {
        this._any = _any;
    }


    /**
     * Gets the name value for this RESOURCE.
     * 
     * @return name
     */
    public org.apache.axis.types.Token getName() {
        return name;
    }


    /**
     * Sets the name value for this RESOURCE.
     * 
     * @param name
     */
    public void setName(org.apache.axis.types.Token name) {
        this.name = name;
    }


    /**
     * Gets the ID value for this RESOURCE.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this RESOURCE.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the type value for this RESOURCE.
     * 
     * @return type
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCEType getType() {
        return type;
    }


    /**
     * Sets the type value for this RESOURCE.
     * 
     * @param type
     */
    public void setType(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCEType type) {
        this.type = type;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RESOURCE)) return false;
        RESOURCE other = (RESOURCE) obj;
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
              this.PARAM.equals(other.getPARAM()))) &&
            ((this.INFO==null && other.getINFO()==null) || 
             (this.INFO!=null &&
              this.INFO.equals(other.getINFO()))) &&
            ((this.COOSYS==null && other.getCOOSYS()==null) || 
             (this.COOSYS!=null &&
              this.COOSYS.equals(other.getCOOSYS()))) &&
            ((this.LINK==null && other.getLINK()==null) || 
             (this.LINK!=null &&
              java.util.Arrays.equals(this.LINK, other.getLINK()))) &&
            ((this.TABLE==null && other.getTABLE()==null) || 
             (this.TABLE!=null &&
              java.util.Arrays.equals(this.TABLE, other.getTABLE()))) &&
            ((this.RESOURCE==null && other.getRESOURCE()==null) || 
             (this.RESOURCE!=null &&
              java.util.Arrays.equals(this.RESOURCE, other.getRESOURCE()))) &&
            ((this._any==null && other.get_any()==null) || 
             (this._any!=null &&
              java.util.Arrays.equals(this._any, other.get_any()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType())));
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
            _hashCode += getPARAM().hashCode();
        }
        if (getINFO() != null) {
            _hashCode += getINFO().hashCode();
        }
        if (getCOOSYS() != null) {
            _hashCode += getCOOSYS().hashCode();
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
        if (getTABLE() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getTABLE());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getTABLE(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRESOURCE() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRESOURCE());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRESOURCE(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
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
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RESOURCE.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCE"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("name");
        attrField.setXmlName(new javax.xml.namespace.QName("", "name"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("type");
        attrField.setXmlName(new javax.xml.namespace.QName("", "type"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCEType"));
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
        elemField.setFieldName("INFO");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "INFO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "INFO"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COOSYS");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LINK");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TABLE");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLE"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RESOURCE");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCE"));
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

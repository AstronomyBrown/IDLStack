/**
 * FIELD.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class FIELD  implements java.io.Serializable {
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUES VALUES;
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] LINK;
    private org.apache.axis.types.Id ID;  // attribute
    private org.apache.axis.types.Token unit;  // attribute
    private fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DataType datatype;  // attribute
    private org.apache.axis.types.Token precision;  // attribute
    private org.apache.axis.types.PositiveInteger width;  // attribute
    private org.apache.axis.types.IDRef ref;  // attribute
    private org.apache.axis.types.Token name;  // attribute
    private org.apache.axis.types.Token ucd;  // attribute
    private java.lang.String utype;  // attribute
    private java.lang.String arraysize;  // attribute

    public FIELD() {
    }


    /**
     * Gets the DESCRIPTION value for this FIELD.
     * 
     * @return DESCRIPTION
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT getDESCRIPTION() {
        return DESCRIPTION;
    }


    /**
     * Sets the DESCRIPTION value for this FIELD.
     * 
     * @param DESCRIPTION
     */
    public void setDESCRIPTION(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }


    /**
     * Gets the VALUES value for this FIELD.
     * 
     * @return VALUES
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUES getVALUES() {
        return VALUES;
    }


    /**
     * Sets the VALUES value for this FIELD.
     * 
     * @param VALUES
     */
    public void setVALUES(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUES VALUES) {
        this.VALUES = VALUES;
    }


    /**
     * Gets the LINK value for this FIELD.
     * 
     * @return LINK
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK[] getLINK() {
        return LINK;
    }


    /**
     * Sets the LINK value for this FIELD.
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
     * Gets the ID value for this FIELD.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this FIELD.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the unit value for this FIELD.
     * 
     * @return unit
     */
    public org.apache.axis.types.Token getUnit() {
        return unit;
    }


    /**
     * Sets the unit value for this FIELD.
     * 
     * @param unit
     */
    public void setUnit(org.apache.axis.types.Token unit) {
        this.unit = unit;
    }


    /**
     * Gets the datatype value for this FIELD.
     * 
     * @return datatype
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DataType getDatatype() {
        return datatype;
    }


    /**
     * Sets the datatype value for this FIELD.
     * 
     * @param datatype
     */
    public void setDatatype(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DataType datatype) {
        this.datatype = datatype;
    }


    /**
     * Gets the precision value for this FIELD.
     * 
     * @return precision
     */
    public org.apache.axis.types.Token getPrecision() {
        return precision;
    }


    /**
     * Sets the precision value for this FIELD.
     * 
     * @param precision
     */
    public void setPrecision(org.apache.axis.types.Token precision) {
        this.precision = precision;
    }


    /**
     * Gets the width value for this FIELD.
     * 
     * @return width
     */
    public org.apache.axis.types.PositiveInteger getWidth() {
        return width;
    }


    /**
     * Sets the width value for this FIELD.
     * 
     * @param width
     */
    public void setWidth(org.apache.axis.types.PositiveInteger width) {
        this.width = width;
    }


    /**
     * Gets the ref value for this FIELD.
     * 
     * @return ref
     */
    public org.apache.axis.types.IDRef getRef() {
        return ref;
    }


    /**
     * Sets the ref value for this FIELD.
     * 
     * @param ref
     */
    public void setRef(org.apache.axis.types.IDRef ref) {
        this.ref = ref;
    }


    /**
     * Gets the name value for this FIELD.
     * 
     * @return name
     */
    public org.apache.axis.types.Token getName() {
        return name;
    }


    /**
     * Sets the name value for this FIELD.
     * 
     * @param name
     */
    public void setName(org.apache.axis.types.Token name) {
        this.name = name;
    }


    /**
     * Gets the ucd value for this FIELD.
     * 
     * @return ucd
     */
    public org.apache.axis.types.Token getUcd() {
        return ucd;
    }


    /**
     * Sets the ucd value for this FIELD.
     * 
     * @param ucd
     */
    public void setUcd(org.apache.axis.types.Token ucd) {
        this.ucd = ucd;
    }


    /**
     * Gets the utype value for this FIELD.
     * 
     * @return utype
     */
    public java.lang.String getUtype() {
        return utype;
    }


    /**
     * Sets the utype value for this FIELD.
     * 
     * @param utype
     */
    public void setUtype(java.lang.String utype) {
        this.utype = utype;
    }


    /**
     * Gets the arraysize value for this FIELD.
     * 
     * @return arraysize
     */
    public java.lang.String getArraysize() {
        return arraysize;
    }


    /**
     * Sets the arraysize value for this FIELD.
     * 
     * @param arraysize
     */
    public void setArraysize(java.lang.String arraysize) {
        this.arraysize = arraysize;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FIELD)) return false;
        FIELD other = (FIELD) obj;
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
            ((this.VALUES==null && other.getVALUES()==null) || 
             (this.VALUES!=null &&
              this.VALUES.equals(other.getVALUES()))) &&
            ((this.LINK==null && other.getLINK()==null) || 
             (this.LINK!=null &&
              java.util.Arrays.equals(this.LINK, other.getLINK()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.unit==null && other.getUnit()==null) || 
             (this.unit!=null &&
              this.unit.equals(other.getUnit()))) &&
            ((this.datatype==null && other.getDatatype()==null) || 
             (this.datatype!=null &&
              this.datatype.equals(other.getDatatype()))) &&
            ((this.precision==null && other.getPrecision()==null) || 
             (this.precision!=null &&
              this.precision.equals(other.getPrecision()))) &&
            ((this.width==null && other.getWidth()==null) || 
             (this.width!=null &&
              this.width.equals(other.getWidth()))) &&
            ((this.ref==null && other.getRef()==null) || 
             (this.ref!=null &&
              this.ref.equals(other.getRef()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.ucd==null && other.getUcd()==null) || 
             (this.ucd!=null &&
              this.ucd.equals(other.getUcd()))) &&
            ((this.utype==null && other.getUtype()==null) || 
             (this.utype!=null &&
              this.utype.equals(other.getUtype()))) &&
            ((this.arraysize==null && other.getArraysize()==null) || 
             (this.arraysize!=null &&
              this.arraysize.equals(other.getArraysize())));
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
        if (getVALUES() != null) {
            _hashCode += getVALUES().hashCode();
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
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getUnit() != null) {
            _hashCode += getUnit().hashCode();
        }
        if (getDatatype() != null) {
            _hashCode += getDatatype().hashCode();
        }
        if (getPrecision() != null) {
            _hashCode += getPrecision().hashCode();
        }
        if (getWidth() != null) {
            _hashCode += getWidth().hashCode();
        }
        if (getRef() != null) {
            _hashCode += getRef().hashCode();
        }
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getUcd() != null) {
            _hashCode += getUcd().hashCode();
        }
        if (getUtype() != null) {
            _hashCode += getUtype().hashCode();
        }
        if (getArraysize() != null) {
            _hashCode += getArraysize().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FIELD.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FIELD"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("datatype");
        attrField.setXmlName(new javax.xml.namespace.QName("", "datatype"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "dataType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("precision");
        attrField.setXmlName(new javax.xml.namespace.QName("", "precision"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("width");
        attrField.setXmlName(new javax.xml.namespace.QName("", "width"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "positiveInteger"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ref");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ref"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("name");
        attrField.setXmlName(new javax.xml.namespace.QName("", "name"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ucd");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ucd"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("utype");
        attrField.setXmlName(new javax.xml.namespace.QName("", "utype"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("arraysize");
        attrField.setXmlName(new javax.xml.namespace.QName("", "arraysize"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DESCRIPTION");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DESCRIPTION"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "anyTEXT"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VALUES");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUES"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUES"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LINK");
        elemField.setXmlName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK"));
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
